class FetchCasePaymentException {
  final String errorMessage;
  final int? code;

  FetchCasePaymentException({required this.errorMessage, required this.code});
}
