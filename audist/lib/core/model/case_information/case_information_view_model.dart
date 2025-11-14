class CaseInformationViewModel {
  CaseInformationViewModel({required this.caseId, required this.userId});

  final String caseId;
  final String userId;

  factory CaseInformationViewModel.fromJson(Map<String, dynamic> json) {
    return CaseInformationViewModel(
      caseId: json["caseID"],
      userId: json["userID"],
    );
  }

  Map<String, dynamic> toJson() => {"caseID": caseId, "userID": userId};
}
