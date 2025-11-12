class AddNewCaseRequestModel {
  AddNewCaseRequestModel({
    required this.refereeNum,
    required this.caseNumb,
    required this.name,
    required this.organization,
    required this.value,
    required this.caseDate,
    required this.image,
    required this.nic,
    required this.userId,
  });

  final String? refereeNum;
  final String? caseNumb;
  final String? name;
  final String? organization;
  final double? value;
  final String? caseDate;
  final String? image;
  final String? nic;
  final String? userId;

  factory AddNewCaseRequestModel.fromJson(Map<String, dynamic> json) {
    return AddNewCaseRequestModel(
      refereeNum: json["refereeNum"],
      caseNumb: json["caseNumb"],
      name: json["name"],
      organization: json["organization"],
      value: json["value"],
      caseDate: json["caseDate"],
      image: json["image"],
      nic: json["nic"],
      userId: json["userID"],
    );
  }

  Map<String, dynamic> toJson() => {
    "refereeNum": refereeNum,
    "caseNumb": caseNumb,
    "name": name,
    "organization": organization,
    "value": value,
    "caseDate": caseDate,
    "image": image,
    "nic": nic,
    "userID": userId,
  };
}
