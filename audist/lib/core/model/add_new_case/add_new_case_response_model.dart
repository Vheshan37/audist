class AddNewCaseResponseModel {
  AddNewCaseResponseModel({required this.newCase});

  final NewCase? newCase;

  factory AddNewCaseResponseModel.fromJson(Map<String, dynamic> json) {
    return AddNewCaseResponseModel(
      newCase: json["newCase"] == null
          ? null
          : NewCase.fromJson(json["newCase"]),
    );
  }

  Map<String, dynamic> toJson() => {"newCase": newCase?.toJson()};
}

class NewCase {
  NewCase({
    required this.caseNumber,
    required this.refereeNo,
    required this.name,
    required this.organization,
    required this.value,
    required this.caseDate,
    required this.image,
    required this.nic,
    required this.userId,
    required this.caseStatusId,
  });

  final String? caseNumber;
  final String? refereeNo;
  final String? name;
  final String? organization;
  final String? value;
  final DateTime? caseDate;
  final String? image;
  final String? nic;
  final String? userId;
  final int? caseStatusId;

  factory NewCase.fromJson(Map<String, dynamic> json) {
    return NewCase(
      caseNumber: json["case_number"],
      refereeNo: json["referee_no"],
      name: json["name"],
      organization: json["organization"],
      value: json["value"],
      caseDate: DateTime.tryParse(json["case_date"] ?? ""),
      image: json["image"],
      nic: json["nic"],
      userId: json["user_id"],
      caseStatusId: json["case_status_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "case_number": caseNumber,
    "referee_no": refereeNo,
    "name": name,
    "organization": organization,
    "value": value,
    "case_date": caseDate?.toIso8601String(),
    "image": image,
    "nic": nic,
    "user_id": userId,
    "case_status_id": caseStatusId,
  };
}
