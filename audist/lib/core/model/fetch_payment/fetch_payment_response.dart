class FetchPaymentResponse {
  FetchPaymentResponse({required this.fetchPaymentResponseCase});

  final Case? fetchPaymentResponseCase;

  factory FetchPaymentResponse.fromJson(Map<String, dynamic> json) {
    return FetchPaymentResponse(
      fetchPaymentResponseCase: json["case"] == null
          ? null
          : Case.fromJson(json["case"]),
    );
  }

  Map<String, dynamic> toJson() => {"case": fetchPaymentResponseCase?.toJson()};
}

class Case {
  Case({
    required this.caseNumber,
    required this.refereeNo,
    required this.name,
    required this.organization,
    required this.value,
    required this.user,
    required this.caseStatus,
    required this.cashCollection,
    required this.totalPaid,
    required this.remaining,
  });

  final String? caseNumber;
  final String? refereeNo;
  final String? name;
  final String? organization;
  final int? value;
  final User? user;
  final CaseStatus? caseStatus;
  final List<CashCollection> cashCollection;
  final int? totalPaid;
  final int? remaining;

  factory Case.fromJson(Map<String, dynamic> json) {
    return Case(
      caseNumber: json["case_number"],
      refereeNo: json["referee_no"],
      name: json["name"],
      organization: json["organization"],
      value: json["value"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
      caseStatus: json["case_status"] == null
          ? null
          : CaseStatus.fromJson(json["case_status"]),
      cashCollection: json["cash_collection"] == null
          ? []
          : List<CashCollection>.from(
              json["cash_collection"]!.map((x) => CashCollection.fromJson(x)),
            ),
      totalPaid: json["total_paid"],
      remaining: json["remaining"],
    );
  }

  Map<String, dynamic> toJson() => {
    "case_number": caseNumber,
    "referee_no": refereeNo,
    "name": name,
    "organization": organization,
    "value": value,
    "user": user?.toJson(),
    "case_status": caseStatus?.toJson(),
    "cash_collection": cashCollection.map((x) => x?.toJson()).toList(),
    "total_paid": totalPaid,
    "remaining": remaining,
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

class CashCollection {
  CashCollection({
    required this.id,
    required this.payment,
    required this.collectionDate,
    required this.remainingAfterPayment,
  });

  final int? id;
  final int? payment;
  final DateTime? collectionDate;
  final int? remainingAfterPayment;

  factory CashCollection.fromJson(Map<String, dynamic> json) {
    return CashCollection(
      id: json["id"],
      payment: json["payment"],
      collectionDate: DateTime.tryParse(json["collection_date"] ?? ""),
      remainingAfterPayment: json["remaining_after_payment"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "payment": payment,
    "collection_date": collectionDate?.toIso8601String(),
    "remaining_after_payment": remainingAfterPayment,
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.divisionId,
    required this.division,
  });

  final String? id;
  final String? name;
  final int? divisionId;
  final Division? division;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      divisionId: json["division_id"],
      division: json["division"] == null
          ? null
          : Division.fromJson(json["division"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "division_id": divisionId,
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
