part of 'add_payment_bloc.dart';

abstract class AddPaymentEvent {}

class RequestAddPayment extends AddPaymentEvent {
  AddPaymentRequestModel request;
  RequestAddPayment({required this.request});
}
