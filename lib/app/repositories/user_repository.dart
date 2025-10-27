import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/helpers/auth_exceptions.dart';
import 'package:checklist/app/services/couchbase_service.dart';

class UserRepository {
  static const userCollection = 'users';

  final CouchbaseService couchbaseService;

  UserRepository({required this.couchbaseService});

  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) {
    throw UnimplementedError('register');
  }

  Future<UserEntity> login({
    required String email,
    required String password,
  }) {
    throw UnimplementedError('login');
  }

  Future<UserEntity> updateUser(
    UserEntity user, {
    String? name,
    String? password,
  }) {
    throw UnimplementedError('updateUser');
  }
}
