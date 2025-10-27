import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:checklist/app/entities/user_entity.dart';
import 'package:checklist/app/helpers/auth_exceptions.dart';
import 'package:checklist/app/logic/auth/auth_state.dart';
import 'package:checklist/app/repositories/user_repository.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(
    this._repository, {
    UserEntity? initialUser,
  })  : _currentUser = initialUser,
        super(initialUser != null
            ? AuthAuthenticated(initialUser)
            : const AuthUnauthenticated());

  final UserRepository _repository;
  UserEntity? _currentUser;

  UserEntity? get currentUser => _currentUser;

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.login(email: email, password: password);
      _currentUser = user;
      emit(AuthAuthenticated(user));
    } on InvalidCredentialsException catch (e) {
      _currentUser = null;
      emit(AuthError(e.message));
      emit(const AuthUnauthenticated());
    } catch (_) {
      _currentUser = null;
      emit(const AuthError('Erro ao autenticar. Tente novamente.'));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      final user = await _repository.register(
        name: name,
        email: email,
        password: password,
      );
      _currentUser = user;
      emit(AuthAuthenticated(user));
    } on UserAlreadyExistsException catch (e) {
      _currentUser = null;
      emit(AuthError(e.message));
      emit(const AuthUnauthenticated());
    } catch (_) {
      _currentUser = null;
      emit(const AuthError('Erro ao cadastrar. Tente novamente.'));
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> updateProfile({
    String? name,
    String? email,
    String? password,
  }) async {
    if (_currentUser == null) {
      emit(const AuthError('Usuário não autenticado.'));
      emit(const AuthUnauthenticated());
      return;
    }

    emit(const AuthLoading());
    try {
      final updatedUser = await _repository.updateUser(
        _currentUser!,
        name: name,
        email: email,
        password: password,
      );
      _currentUser = updatedUser;
      emit(AuthAuthenticated(updatedUser));
    } on UserAlreadyExistsException catch (e) {
      emit(AuthError(e.message));
      emit(AuthAuthenticated(_currentUser!));
    } catch (_) {
      emit(const AuthError('Erro ao atualizar dados. Tente novamente.'));
      emit(AuthAuthenticated(_currentUser!));
    }
  }

  void logout() {
    _currentUser = null;
    emit(const AuthUnauthenticated());
  }
}
