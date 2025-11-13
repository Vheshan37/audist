class CaseInformationRequest {
  CaseInformationRequest({
    required this.userId,
    required this.caseId,
    required this.respondent,
    required this.nextCaseDate,
    required this.judgement,
    required this.other,
  });

  final String? userId;
  final String? caseId;
  final Respondent? respondent;
  final DateTime? nextCaseDate;
  final Judgement? judgement;
  final Other? other;

  factory CaseInformationRequest.fromJson(Map<String, dynamic> json) {
    return CaseInformationRequest(
      userId: json["userID"],
      caseId: json["caseID"],
      respondent: json["respondent"] == null
          ? null
          : Respondent.fromJson(json["respondent"]),
      nextCaseDate: DateTime.tryParse(json["nextCaseDate"] ?? ""),
      judgement: json["judgement"] == null
          ? null
          : Judgement.fromJson(json["judgement"]),
      other: json["other"] == null ? null : Other.fromJson(json["other"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "userID": userId,
    "caseID": caseId,
    "respondent": respondent?.toJson(),
    "nextCaseDate":
        "${nextCaseDate?.year.toString().padLeft(4, '0')}-${nextCaseDate?.month.toString().padLeft(2, '0')}-${nextCaseDate?.day.toString().padLeft(2, '0')}",
    "judgement": judgement?.toJson(),
    "other": other?.toJson(),
  };
}

class Judgement {
  Judgement({
    required this.settlementFee,
    required this.nextSettlementDate,
    required this.todayPayment,
  });

  final int? settlementFee;
  final DateTime? nextSettlementDate;
  final int? todayPayment;

  factory Judgement.fromJson(Map<String, dynamic> json) {
    return Judgement(
      settlementFee: json["settlementFee"],
      nextSettlementDate: DateTime.tryParse(json["nextSettlementDate"] ?? ""),
      todayPayment: json["todayPayment"],
    );
  }

  Map<String, dynamic> toJson() => {
    "settlementFee": settlementFee,
    "nextSettlementDate":
        "${nextSettlementDate?.year.toString().padLeft(4, '0')}-${nextSettlementDate?.month.toString().padLeft(2, '0')}-${nextSettlementDate?.day.toString().padLeft(2, '0')}",
    "todayPayment": todayPayment,
  };
}

class Other {
  Other({required this.withdraw, required this.testimony, required this.image});

  final bool? withdraw;
  final bool? testimony;
  final String? image;

  factory Other.fromJson(Map<String, dynamic> json) {
    return Other(
      withdraw: json["withdraw"],
      testimony: json["testimony"],
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "withdraw": withdraw,
    "testimony": testimony,
    "image": image,
  };
}

class Respondent {
  Respondent({
    required this.person1,
    required this.person2,
    required this.person3,
  });

  final String? person1;
  final String? person2;
  final String? person3;

  factory Respondent.fromJson(Map<String, dynamic> json) {
    return Respondent(
      person1: json["person1"],
      person2: json["person2"],
      person3: json["person3"],
    );
  }

  Map<String, dynamic> toJson() => {
    "person1": person1,
    "person2": person2,
    "person3": person3,
  };
}
