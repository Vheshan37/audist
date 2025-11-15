part of 'add_payment_bloc.dart';

abstract class AddPaymentState {}

class AddPaymentInitial extends AddPaymentState {}

class AddPaymentLoading extends AddPaymentState {}

class AddPaymentSuccess extends AddPaymentState {
  AddPaymentResponseModel response;
  AddPaymentSuccess({required this.response});
}

class AddPaymentFailed extends AddPaymentState {
  final String message;
  AddPaymentFailed({required this.message});
}
