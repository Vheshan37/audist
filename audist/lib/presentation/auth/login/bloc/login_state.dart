part of 'login_bloc.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final String message;
  final String? userId;
  final String? email;

  LoginSuccess({
    required this.message,
    required this.userId,
    required this.email,
  });
}

class LoginFailed extends LoginState {
  final String message;

  LoginFailed({required this.message});
}
