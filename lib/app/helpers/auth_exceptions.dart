class UserAlreadyExistsException implements Exception {
  final String message;

  UserAlreadyExistsException([this.message = 'Usuário já cadastrado.']);

  @override
  String toString() => 'UserAlreadyExistsException: $message';
}

class InvalidCredentialsException implements Exception {
  final String message;

  InvalidCredentialsException([this.message = 'Credenciais inválidas.']);

  @override
  String toString() => 'InvalidCredentialsException: $message';
}

class UserNotFoundException implements Exception {
  final String message;

  UserNotFoundException([this.message = 'Usuário não encontrado.']);

  @override
  String toString() => 'UserNotFoundException: $message';
}
