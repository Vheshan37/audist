class FetchCaseException implements Exception {
  final int code;
  final String message;

  FetchCaseException({required this.code, required this.message});
}