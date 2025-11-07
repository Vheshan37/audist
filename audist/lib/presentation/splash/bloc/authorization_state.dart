part of 'authorization_bloc.dart';

abstract class AuthorizationState {}

class AuthorizationInitial extends AuthorizationState {}

class AuthorizationLoading extends AuthorizationState {}

class Authorized extends AuthorizationState {
  final String uid;
  Authorized({required this.uid});
}

class Logout extends AuthorizationState {}

class LogoutFailed extends AuthorizationState {}

class AuthorizationFailed extends AuthorizationState {}
