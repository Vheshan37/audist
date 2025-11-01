part of 'login_bloc.dart';

abstract class LoginEvent {}

class RequestLogin extends LoginEvent {
  final String email;
  final String password;

  RequestLogin(this.email, this.password);
}
