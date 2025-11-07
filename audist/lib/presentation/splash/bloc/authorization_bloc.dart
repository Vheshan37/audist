import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'authorization_event.dart';
part 'authorization_state.dart';

class AuthorizationBloc extends Bloc<AuthorizationEvent, AuthorizationState> {
  AuthorizationBloc() : super(AuthorizationInitial()) {
    final FirebaseAuth auth = FirebaseAuth.instance;

    on<AuthorizationEvent>((event, emit) {
      User? user = auth.currentUser;
      if (user != null) {
        emit(Authorized(uid: user.uid));
      } else {
        emit(AuthorizationFailed());
      }
    });

    on<RequestLogout>((event, emit) async {
      try {
        await auth.signOut();
        emit(Logout());
        debugPrint('Log out success');
      } catch (e) {
        emit(LogoutFailed());
        debugPrint('Log out failed');
      }
    });
  }
}
