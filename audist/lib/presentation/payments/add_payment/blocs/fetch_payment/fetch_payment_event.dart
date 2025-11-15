part of 'fetch_payment_bloc.dart';

abstract class FetchPaymentEvent {}

class RequestFetchPayment extends FetchPaymentEvent {
  final FetchPaymentRequest request;
  RequestFetchPayment({required this.request});
}
