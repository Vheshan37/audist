part of 'fetch_payment_bloc.dart';

abstract class FetchPaymentState {}

class FetchPaymentInitial extends FetchPaymentState {}

class FetchPaymentLoading extends FetchPaymentState {}

class FetchPaymentSuccess extends FetchPaymentState {
  final FetchPaymentResponse data;
  FetchPaymentSuccess({required this.data});
}

class FetchPaymentFailed extends FetchPaymentState {
  final String message;
  FetchPaymentFailed({required this.message});
}
