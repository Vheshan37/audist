import 'dart:convert';

import 'package:audist/common/helpers/converter_helper.dart';
import 'package:audist/common/helpers/date_formatter.dart';
import 'package:intl/intl.dart';

class AddPaymentRequestModel {
  AddPaymentRequestModel({
    required this.caseNumber,
    required this.payment,
    required this.paymentDate,
    required this.nextPaymentDate,
    required this.description,
    required this.userId,
  });

  final String caseNumber;
  final int payment;
  final DateTime paymentDate;
  final DateTime nextPaymentDate;
  final String description;
  final String userId;

  factory AddPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return AddPaymentRequestModel(
      caseNumber: json["case_number"],
      payment: json["payment"],
      paymentDate: ConverterHelper.parseDate(json["payment_date"]),
      nextPaymentDate: ConverterHelper.parseDate(json["next_payment_date"]),
      description: json["description"],
      userId: json["userID"],
    );
  }

  Map<String, dynamic> toJson() => {
    "case_number": caseNumber,
    "payment": payment,
    "payment_date": ConverterHelper.dateTimeToString(paymentDate),
    "next_payment_date": ConverterHelper.dateTimeToString(nextPaymentDate),
    "description": description,
    "userID": userId,
  };
}
