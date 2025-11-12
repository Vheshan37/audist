class AllCaseModel {
  AllCaseModel({
    required this.pending,
    required this.ongoing,
    required this.complete,
    required this.testimony,
  });

  final List<CaseObject> pending;
  final List<CaseObject> ongoing;
  final List<CaseObject> complete;
  final List<CaseObject> testimony;

  factory AllCaseModel.fromJson(Map<String, dynamic> json) {
    return AllCaseModel(
      pending: json["pending"] == null
          ? []
          : List<CaseObject>.from(
              json["pending"]!.map((x) => CaseObject.fromJson(x)),
            ),
      ongoing: json["ongoing"] == null
          ? []
          : List<CaseObject>.from(
              json["ongoing"]!.map((x) => CaseObject.fromJson(x)),
            ),
      complete: json["complete"] == null
          ? []
          : List<CaseObject>.from(
              json["complete"]!.map((x) => CaseObject.fromJson(x)),
            ),
      testimony: json["testimony"] == null
          ? []
          : List<CaseObject>.from(
              json["testimony"]!.map((x) => CaseObject.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "pending": pending.map((x) => x.toJson()).toList(),
    "ongoing": ongoing.map((x) => x.toJson()).toList(),
    "complete": complete.map((x) => x.toJson()).toList(),
    "testimony": testimony.map((x) => x.toJson()).toList(),
  };
}

class CaseObject {
  CaseObject({
    required this.caseNumber,
    required this.refereeNo,
    required this.name,
    required this.organization,
    required this.value,
    required this.caseDate,
    required this.image,
    required this.nic,
    required this.user,
    required this.caseStatus,
  });

  final String? caseNumber;
  final String? refereeNo;
  final String? name;
  final String? organization;
  final double? value;
  final DateTime? caseDate;
  final String? image;
  final String? nic;
  final User? user;
  final CaseStatus? caseStatus;

  factory CaseObject.fromJson(Map<String, dynamic> json) {
    return CaseObject(
      caseNumber: json["case_number"],
      refereeNo: json["referee_no"],
      name: json["name"],
      organization: json["organization"],
      value: (json["value"] is int)
          ? (json["value"] as int).toDouble()
          : (json["value"] as double?),
      caseDate: DateTime.tryParse(json["case_date"] ?? ""),
      image: json["image"],
      nic: json["nic"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      caseStatus: json["case_status"] == null
          ? null
          : CaseStatus.fromJson(json["case_status"]),
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
    "user": user?.toJson(),
    "case_status": caseStatus?.toJson(),
  };
}

class CaseStatus {
  CaseStatus({required this.status});

  final String? status;

  factory CaseStatus.fromJson(Map<String, dynamic> json) {
    return CaseStatus(status: json["status"]);
  }

  Map<String, dynamic> toJson() => {"status": status};
}

class User {
  User({required this.name, required this.division});

  final String? name;
  final Division? division;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json["name"],
      division: json["division"] == null
          ? null
          : Division.fromJson(json["division"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "name": name,
    "division": division?.toJson(),
  };
}

class Division {
  Division({required this.id, required this.division});

  final int? id;
  final String? division;

  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(id: json["id"], division: json["division"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "division": division};
}
