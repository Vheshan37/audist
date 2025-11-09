class AddPaymentRequest {
  AddPaymentRequest({
    required this.caseNumber,
    required this.payment,
    required this.paymentDate,
    required this.nextPaymentDate,
    required this.description,
  });

  final String? caseNumber;
  final String? payment;
  final DateTime? paymentDate;
  final DateTime? nextPaymentDate;
  final String? description;

  factory AddPaymentRequest.fromJson(Map<String, dynamic> json) {
    return AddPaymentRequest(
      caseNumber: json["case_number"],
      payment: json["payment"],
      paymentDate: DateTime.tryParse(json["payment_date"] ?? ""),
      nextPaymentDate: DateTime.tryParse(json["next_payment_date"] ?? ""),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "case_number": caseNumber,
    "payment": payment,
    "payment_date":
        "${paymentDate?.year.toString().padLeft(4, '0')}-${paymentDate?.month.toString().padLeft(2, '0')}-${paymentDate?.day.toString().padLeft(2, '0')}",
    "next_payment_date":
        "${nextPaymentDate?.year.toString().padLeft(4, '0')}-${nextPaymentDate?.month.toString().padLeft(2, '0')}-${nextPaymentDate?.day.toString().padLeft(2, '0')}",
    "description": description,
  };
}
