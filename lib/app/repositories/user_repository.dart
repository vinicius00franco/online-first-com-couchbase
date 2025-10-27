import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/helpers/auth_exceptions.dart';
import 'package:checklist/app/services/couchbase_service.dart';
import 'package:checklist/app/utils/couchbase_constants.dart';

class UserRepository {
  static String get userCollection => CouchbaseContants.userCollection;

  final CouchbaseService couchbaseService;

  UserRepository({required this.couchbaseService});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final existing = await _findByEmail(normalizedEmail);
    if (existing != null) {
      throw UserAlreadyExistsException();
    }

    final now = DateTime.now().toUtc();
    final salt = _generateSalt();
    final passwordHash = _hashPassword(password, salt);

    final user = UserEntity(
      name: name.trim(),
      email: normalizedEmail,
      passwordHash: passwordHash,
      salt: salt,
      createdAt: now,
      updatedAt: now,
    );

    final id = await couchbaseService.add(
      data: user.toMap(),
      collectionName: userCollection,
    );

    if (id == null) {
      throw Exception('Não foi possível criar o usuário.');
    }

    return user.copyWith(id: id);
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    final normalizedEmail = _normalizeEmail(email);
    final user = await _findByEmail(normalizedEmail);

    if (user == null) {
      throw InvalidCredentialsException();
    }

    final hash = _hashPassword(password, user.salt);
    if (hash != user.passwordHash) {
      throw InvalidCredentialsException();
    }

    return user;
  }

  Future<UserEntity> updateUser(
    UserEntity user, {
    String? name,
    String? password,
    String? email,
  }) async {
    if (user.id == null) {
      throw UserNotFoundException('Usuário sem identificador.');
    }

    final updates = <String, dynamic>{};
    var updatedUser = user;

    if (name != null && name.trim().isNotEmpty && name.trim() != user.name) {
      updates['name'] = name.trim();
      updatedUser = updatedUser.copyWith(name: name.trim());
    }

    if (email != null && email.trim().isNotEmpty) {
      final normalizedEmail = _normalizeEmail(email);
      if (normalizedEmail != user.email) {
        final conflict = await _findByEmail(normalizedEmail);
        if (conflict != null && conflict.id != user.id) {
          throw UserAlreadyExistsException('E-mail já está em uso.');
        }
        updates['email'] = normalizedEmail;
        updatedUser = updatedUser.copyWith(email: normalizedEmail);
      }
    }

    if (password != null && password.isNotEmpty) {
      final newSalt = _generateSalt();
      final newHash = _hashPassword(password, newSalt);
      updates['passwordHash'] = newHash;
      updates['salt'] = newSalt;
      updatedUser = updatedUser.copyWith(
        passwordHash: newHash,
        salt: newSalt,
      );
    }

    if (updates.isEmpty) {
      return updatedUser;
    }

    final now = DateTime.now().toUtc();
    updates['updatedAt'] = now.toIso8601String();
    updatedUser = updatedUser.copyWith(updatedAt: now);

    final success = await couchbaseService.edit(
      collectionName: userCollection,
      id: user.id!,
      data: updates,
    );

    if (!success) {
      throw UserNotFoundException('Não foi possível atualizar o usuário.');
    }

    return updatedUser;
  }

  Future<UserEntity?> _findByEmail(String email) async {
    final data = await couchbaseService.fetch(
      collectionName: userCollection,
    );

    for (final item in data) {
      final storedEmail = (item['email'] as String).toLowerCase();
      if (storedEmail == email) {
        return UserEntity.fromMap(item);
      }
    }

    return null;
  }

  String _hashPassword(String password, String salt) {
    final bytes = utf8.encode('$salt$password');
    return sha256.convert(bytes).toString();
  }

  String _generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Url.encode(bytes);
  }

  String _normalizeEmail(String email) => email.trim().toLowerCase();
}
