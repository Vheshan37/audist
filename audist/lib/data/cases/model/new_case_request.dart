class NewCaseRequest {
  final String caseId;
  final String caseNumber;
  final String name;
  final String nic;
  final String organization;
  final String value;
  final String nextHearingDate;
  final String? imagePath;

  NewCaseRequest({
    required this.caseId,
    required this.caseNumber,
    required this.name,
    required this.nic,
    required this.organization,
    required this.value,
    required this.nextHearingDate,
    this.imagePath,
  });
}