import 'package:checklist/app/helpers/auth_exceptions.dart';
import 'package:checklist/app/repositories/user_repository.dart';
import 'package:checklist/app/services/couchbase_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:checklist/app/entities/user_entity.dart';

class FakeCouchbaseService extends CouchbaseService {
  final Map<String, Map<String, Map<String, dynamic>>> _collections = {};
  int _counter = 0;

  Map<String, dynamic>? getStoredDoc(String collection, String id) {
    return _collections[collection]?[id];
  }

  @override
  Future<String?> add({
    required Map<String, dynamic> data,
    required String collectionName,
    String? documentId,
  }) async {
    final id = documentId ?? 'doc_${_counter++}';
    final collection = _collections.putIfAbsent(
        collectionName, () => <String, Map<String, dynamic>>{});
    collection[id] = {...data};
    return id;
  }

  @override
  Future<List<Map<String, dynamic>>> fetch({
    required String collectionName,
    String? filter,
  }) async {
    final collection = _collections[collectionName];
    if (collection == null) {
      return [];
    }

    Iterable<MapEntry<String, Map<String, dynamic>>> entries =
        collection.entries;

    if (filter != null) {
      final emailMatch = RegExp(r'email\s*=\s*"([^"]+)"').firstMatch(filter);
      if (emailMatch != null) {
        final email = emailMatch.group(1);
        entries = entries.where((entry) => entry.value['email'] == email);
      }
    }

    return entries
        .map((entry) => {
              'id': entry.key,
              ...entry.value,
            })
        .toList();
  }

  @override
  Future<bool> edit({
    required String collectionName,
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final collection = _collections[collectionName];
    if (collection == null || !collection.containsKey(id)) {
      return false;
    }

    final current = collection[id]!;
    data.forEach((key, value) {
      current[key] = value;
    });
    return true;
  }
}

void main() {
  group('UserRepository', () {
    late FakeCouchbaseService fakeService;
    late UserRepository repository;

    setUp(() {
      fakeService = FakeCouchbaseService();
      repository = UserRepository(couchbaseService: fakeService);
    });

    test('register creates a user with hashed password', () async {
      final user = await repository.register(
        name: 'Vinicius',
        email: 'user@example.com',
        password: 'secret123',
      );

      expect(user.id, isNotEmpty);
      expect(user.passwordHash, isNot('secret123'));
      expect(user.salt, isNotEmpty);
      final stored =
          fakeService.getStoredDoc(UserRepository.userCollection, user.id!);
      expect(stored, isNotNull);
      expect(stored!['passwordHash'], user.passwordHash);
      expect(stored['salt'], user.salt);
    });

    test('register throws when email already exists', () async {
      await repository.register(
        name: 'Vinicius',
        email: 'duplicated@example.com',
        password: 'secret123',
      );

      expect(
        () => repository.register(
          name: 'Other',
          email: 'duplicated@example.com',
          password: 'another',
        ),
        throwsA(isA<UserAlreadyExistsException>()),
      );
    });

    test('login succeeds with correct credentials', () async {
      final created = await repository.register(
        name: 'Vinicius',
        email: 'login@example.com',
        password: 'secret123',
      );

      final logged = await repository.login(
        email: 'login@example.com',
        password: 'secret123',
      );

      expect(logged.id, created.id);
      expect(logged.email, created.email);
    });

    test('login throws when password is invalid', () async {
      await repository.register(
        name: 'Vinicius',
        email: 'invalid@example.com',
        password: 'secret123',
      );

      expect(
        () => repository.login(email: 'invalid@example.com', password: 'wrong'),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });

    test('updateUser changes the name', () async {
      final created = await repository.register(
        name: 'Vinicius',
        email: 'update@example.com',
        password: 'secret123',
      );

      final updated = await repository.updateUser(
        created,
        name: 'New Name',
      );

      expect(updated.name, 'New Name');
      final stored =
          fakeService.getStoredDoc(UserRepository.userCollection, created.id!);
      expect(stored!['name'], 'New Name');
    });

    test('updateUser rehashes password when provided', () async {
      final created = await repository.register(
        name: 'Vinicius',
        email: 'password@example.com',
        password: 'secret123',
      );

      final updated = await repository.updateUser(
        created,
        password: 'newPassword',
      );

      expect(updated.passwordHash, isNot(created.passwordHash));
      expect(updated.salt, isNot(created.salt));

      final login = await repository.login(
        email: 'password@example.com',
        password: 'newPassword',
      );

      expect(login.id, created.id);
    });
  });
}
