class FetchPaymentRequest {
  FetchPaymentRequest({
    required this.caseNumb,
    required this.userId,
    required this.includePayments,
  });

  final String caseNumb;
  final String userId;
  final bool includePayments;

  factory FetchPaymentRequest.fromJson(Map<String, dynamic> json) {
    return FetchPaymentRequest(
      caseNumb: json["caseNumb"],
      userId: json["userID"],
      includePayments: json["includePayments"],
    );
  }

  Map<String, dynamic> toJson() => {
    "caseNumb": caseNumb,
    "userID": userId,
    "includePayments": includePayments,
  };
}
