import 'package:bloc_test/bloc_test.dart';
import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/helpers/auth_exceptions.dart';
import 'package:checklist/app/logic/auth/auth_cubit.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/repositories/user_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository repository;
  late UserEntity user;

  setUpAll(() {
    registerFallbackValue(
      UserEntity(
        id: 'fallback',
        name: 'Fallback',
        email: 'fallback@example.com',
        passwordHash: 'hash',
        salt: 'salt',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      ),
    );
  });

  setUp(() {
    repository = MockUserRepository();
    user = UserEntity(
      id: '1',
      name: 'Vinicius',
      email: 'user@example.com',
      passwordHash: 'hash',
      salt: 'salt',
      createdAt: DateTime(2024),
      updatedAt: DateTime(2024),
    );
  });

  blocTest<AuthCubit, AuthState>(
    'emits AuthAuthenticated when login succeeds',
    build: () {
      when(() => repository.login(
          email: any(named: 'email'),
          password: any(named: 'password'))).thenAnswer((_) async => user);
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.login(email: 'user@example.com', password: 'secret'),
    expect: () => [
      const AuthLoading(),
      AuthAuthenticated(user),
    ],
    verify: (cubit) => expect(cubit.currentUser, equals(user)),
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthError when login fails',
    build: () {
      when(() => repository.login(
              email: any(named: 'email'), password: any(named: 'password')))
          .thenThrow(InvalidCredentialsException('Credenciais inválidas.'));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.login(email: 'user@example.com', password: 'wrong'),
    expect: () => [
      const AuthLoading(),
      const AuthError('Credenciais inválidas.'),
      const AuthUnauthenticated(),
    ],
    verify: (cubit) => expect(cubit.currentUser, isNull),
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthAuthenticated when register succeeds',
    build: () {
      when(() => repository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => user);
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.register(
        name: 'Vinicius', email: 'user@example.com', password: 'secret'),
    expect: () => [
      const AuthLoading(),
      AuthAuthenticated(user),
    ],
    verify: (cubit) => expect(cubit.currentUser, equals(user)),
  );

  blocTest<AuthCubit, AuthState>(
    'emits AuthError when register fails',
    build: () {
      when(() => repository.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(UserAlreadyExistsException('Usuário já cadastrado.'));
      return AuthCubit(repository);
    },
    act: (cubit) => cubit.register(
        name: 'Vinicius', email: 'user@example.com', password: 'secret'),
    expect: () => [
      const AuthLoading(),
      const AuthError('Usuário já cadastrado.'),
      const AuthUnauthenticated(),
    ],
    verify: (cubit) => expect(cubit.currentUser, isNull),
  );

  blocTest<AuthCubit, AuthState>(
    'updateProfile emits updated user when authenticated',
    build: () {
      late UserEntity updatedUser;
      updatedUser = user.copyWith(name: 'Novo Nome');
      when(() => repository.updateUser(
            any(),
            name: any(named: 'name'),
            password: any(named: 'password'),
            email: any(named: 'email'),
          )).thenAnswer((_) async => updatedUser);
      return AuthCubit(repository, initialUser: user);
    },
    act: (cubit) => cubit.updateProfile(name: 'Novo Nome'),
    expect: () => [
      const AuthLoading(),
      AuthAuthenticated(user.copyWith(name: 'Novo Nome')),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'updateProfile emits AuthError when no authenticated user',
    build: () => AuthCubit(repository),
    act: (cubit) => cubit.updateProfile(name: 'Novo Nome'),
    expect: () => [
      const AuthError('Usuário não autenticado.'),
      const AuthUnauthenticated(),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'updateProfile errors keep the user authenticated',
    build: () {
      when(() => repository.updateUser(
            any(),
            name: any(named: 'name'),
            password: any(named: 'password'),
            email: any(named: 'email'),
          )).thenThrow(UserAlreadyExistsException('E-mail já está em uso.'));
      return AuthCubit(repository, initialUser: user);
    },
    act: (cubit) => cubit.updateProfile(email: 'other@example.com'),
    expect: () => [
      const AuthLoading(),
      const AuthError('E-mail já está em uso.'),
      AuthAuthenticated(user),
    ],
  );

  blocTest<AuthCubit, AuthState>(
    'logout resets the state to unauthenticated',
    build: () => AuthCubit(repository, initialUser: user),
    act: (cubit) => cubit.logout(),
    expect: () => [
      const AuthUnauthenticated(),
    ],
    verify: (cubit) => expect(cubit.currentUser, isNull),
  );
}
