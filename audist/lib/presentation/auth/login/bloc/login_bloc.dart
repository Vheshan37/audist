import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<RequestLogin>((event, emit) {
      emit(LoginLoading());

      // try, catch process to firebase login
    });
  }
}
