class CaseInformationUpdateException implements Exception {
  final String message;
  CaseInformationUpdateException(this.message);

  @override
  String toString() => message;
}
