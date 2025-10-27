import 'package:checklist/app/entities/user_entity.dart';

abstract class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthUnauthenticated;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthLoading extends AuthState {
  const AuthLoading();

  @override
  bool operator ==(Object other) => identical(this, other) || other is AuthLoading;

  @override
  int get hashCode => runtimeType.hashCode;
}

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated(this.user);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuthAuthenticated && other.user == user);

  @override
  int get hashCode => Object.hash(runtimeType, user);
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuthError && other.message == message);

  @override
  int get hashCode => Object.hash(runtimeType, message);
}
