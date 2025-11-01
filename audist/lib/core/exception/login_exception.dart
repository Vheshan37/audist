class LoginException implements Exception {
  final int code;
  final String message;

  LoginException({required this.code, required this.message});
}
