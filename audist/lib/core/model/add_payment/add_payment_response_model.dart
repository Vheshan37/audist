class AddPaymentResponse {
  AddPaymentResponse({
    required this.message,
    required this.payment,
    required this.caseUpdate,
  });

  final String? message;
  final Payment? payment;
  final CaseUpdate? caseUpdate;

  factory AddPaymentResponse.fromJson(Map<String, dynamic> json){
    return AddPaymentResponse(
      message: json["message"],
      payment: json["payment"] == null ? null : Payment.fromJson(json["payment"]),
      caseUpdate: json["case_update"] == null ? null : CaseUpdate.fromJson(json["case_update"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "payment": payment?.toJson(),
    "case_update": caseUpdate?.toJson(),
  };

}

class CaseUpdate {
  CaseUpdate({
    required this.count,
  });

  final int? count;

  factory CaseUpdate.fromJson(Map<String, dynamic> json){
    return CaseUpdate(
      count: json["count"],
    );
  }

  Map<String, dynamic> toJson() => {
    "count": count,
  };

}

class Payment {
  Payment({
    required this.id,
    required this.caseNumber,
    required this.payment,
    required this.collectionDate,
    required this.description,
  });

  final int? id;
  final String? caseNumber;
  final int? payment;
  final DateTime? collectionDate;
  final String? description;

  factory Payment.fromJson(Map<String, dynamic> json){
    return Payment(
      id: json["id"],
      caseNumber: json["case_number"],
      payment: json["payment"],
      collectionDate: DateTime.tryParse(json["collection_date"] ?? ""),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "case_number": caseNumber,
    "payment": payment,
    "collection_date": collectionDate?.toIso8601String(),
    "description": description,
  };

}