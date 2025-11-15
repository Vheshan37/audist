import 'package:audist/common/helpers/converter_helper.dart';

class AddPaymentResponseModel {
  AddPaymentResponseModel({
    required this.message,
    required this.payment,
    required this.totalPaid,
    required this.remaining,
    required this.caseStatus,
  });

  final String message;
  final Payment payment;
  final int totalPaid;
  final int remaining;
  final String caseStatus;

  factory AddPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return AddPaymentResponseModel(
      message: json["message"],
      payment: Payment.fromJson(json["payment"]),
      totalPaid: json["total_paid"],
      remaining: json["remaining"],
      caseStatus: json["case_status"],
    );
  }

  Map<String, dynamic> toJson() => {
    "message": message,
    "payment": payment.toJson(),
    "total_paid": totalPaid,
    "remaining": remaining,
    "case_status": caseStatus,
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

  final int id;
  final String caseNumber;
  final int payment;
  final DateTime collectionDate;
  final String? description;

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json["id"],
      caseNumber: json["case_number"],
      payment: json["payment"],
      collectionDate: ConverterHelper.parseDate(json["collection_date"]),
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "case_number": caseNumber,
    "payment": payment,
    "collection_date": ConverterHelper.dateTimeToCustomString(
      collectionDate,
      "dd/MM/YYYY",
    ),
    "description": description,
  };
}
