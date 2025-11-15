class CaseInformationResponseModel {
  CaseInformationResponseModel({
    required this.caseInformationResponseCase,
    required this.respondent,
    required this.information,
    required this.payments,
  });

  final Case? caseInformationResponseCase;
  final Respondent? respondent;
  final Information? information;
  final List<Payment> payments;

  factory CaseInformationResponseModel.fromJson(Map<String, dynamic> json) {
    return CaseInformationResponseModel(
      caseInformationResponseCase: json["case"] == null
          ? null
          : Case.fromJson(json["case"]),
      respondent: json["respondent"] == null
          ? null
          : Respondent.fromJson(json["respondent"]),
      information: json["information"] == null
          ? null
          : Information.fromJson(json["information"]),
      payments: json["payments"] == null
          ? []
          : List<Payment>.from(
              json["payments"]!.map((x) => Payment.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    "case": caseInformationResponseCase?.toJson(),
    "respondent": respondent?.toJson(),
    "information": information?.toJson(),
    "payments": payments.map((x) => x.toJson()).toList(),
  };
}

class Case {
  Case({
    required this.caseNumber,
    required this.refereeNo,
    required this.name,
    required this.organization,
    required this.value,
    required this.date,
    required this.status,
    required this.nic,
    required this.userId,
  });

  final String? caseNumber;
  final String? refereeNo;
  final String? name;
  final String? organization;
  final int? value;
  final DateTime? date;
  final Status? status;
  final String? nic;
  final String? userId;

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      caseNumber: json["caseNumber"],
      refereeNo: json["refereeNo"],
      name: json["name"],
      organization: json["organization"],
      value: json["value"],
      date: DateTime.tryParse(json["date"] ?? ""),
      status: json["status"] == null ? null : Status.fromJson(json["status"]),
      nic: json["nic"],
      userId: json["user_id"],
    );
  }

  Map<String, dynamic> toJson() => {
    "caseNumber": caseNumber,
    "refereeNo": refereeNo,
    "name": name,
    "organization": organization,
    "value": value,
    "date": date?.toIso8601String(),
    "status": status?.toJson(),
  };
}

class Status {
  Status({required this.id, required this.label});

  final int? id;
  final String? label;

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(id: json["id"], label: json["label"]);
  }

  Map<String, dynamic> toJson() => {"id": id, "label": label};
}

class Information {
  Information({
    required this.phase,
    required this.settlementFee,
    required this.nextSettlementDate,
    required this.image,
  });

  final int? phase;
  final int? settlementFee;
  final DateTime? nextSettlementDate;
  final String? image;

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
      phase: json["phase"],
      settlementFee: json["settlementFee"],
      nextSettlementDate: DateTime.tryParse(json["nextSettlementDate"] ?? ""),
      image: json["image"],
    );
  }

  Map<String, dynamic> toJson() => {
    "phase": phase,
    "settlementFee": settlementFee,
    "nextSettlementDate": nextSettlementDate?.toIso8601String(),
    "image": image,
  };
}

class Payment {
  Payment({
    required this.payment,
    required this.date,
    required this.description,
  });

  final int? payment;
  final DateTime? date;
  final String? description;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      payment: json["payment"],
      date: DateTime.tryParse(json["date"] ?? ""),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "payment": payment,
    "date": date?.toIso8601String(),
    "description": description,
  };
}

class Respondent {
  Respondent({
    required this.person1,
    required this.person2,
    required this.person3,
  });

  final Person? person1;
  final Person? person2;
  final Person? person3;

  factory Respondent.fromJson(Map<String, dynamic> json) {
    return Respondent(
      person1: json["person1"] == null
          ? null
          : Person.fromJson(json["person1"]),
      person2: json["person2"] == null
          ? null
          : Person.fromJson(json["person2"]),
      person3: json["person3"] == null
          ? null
          : Person.fromJson(json["person3"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "person1": person1?.toJson(),
    "person2": person2?.toJson(),
    "person3": person3?.toJson(),
  };
}

class Person {
  Person({required this.statusId, required this.status});

  final int? statusId;
  final String? status;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(statusId: json["statusId"], status: json["status"]);
  }

  Map<String, dynamic> toJson() => {"statusId": statusId, "status": status};
}
