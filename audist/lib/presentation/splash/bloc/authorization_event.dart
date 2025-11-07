part of 'authorization_bloc.dart';

abstract class AuthorizationEvent{}

class RequestAuthorization extends AuthorizationEvent{}
class RequestLogout extends AuthorizationEvent{}