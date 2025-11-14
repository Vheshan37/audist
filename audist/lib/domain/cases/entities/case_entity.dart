class CaseEntity {
  CaseEntity({
    required this.caseNumber,
    required this.refereeNo,
    required this.name,
    required this.organization,
    required this.value,
    required this.caseDate,
    required this.createdAt,
    required this.image,
    required this.nic,
    required this.userId,
  });

  final String? caseNumber;
  final String? refereeNo;
  final String? name;
  final String? organization;
  final double? value;
  final DateTime? caseDate;
  final DateTime? createdAt;
  final String? image;
  final String? nic;
  final String? userId;

  factory CaseEntity.fromJson(Map<String, dynamic> json) {
    return CaseEntity(
      caseNumber: json["case_number"],
      refereeNo: json["referee_no"],
      name: json["name"],
      organization: json["organization"],
      value: (json["value"] is int)
          ? (json["value"] as int).toDouble()
          : (json["value"] as double?),
      caseDate: DateTime.tryParse(json["case_date"] ?? ""),
      createdAt: DateTime.tryParse(json["created_at"] ?? ""),
      image: json["image"],
      nic: json["nic"],
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "case_number": caseNumber,
    "referee_no": refereeNo,
    "name": name,
    "organization": organization,
    "value": value,
    "case_date": caseDate?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "image": image,
    "nic": nic,
    "user_id": userId,
  };
}
