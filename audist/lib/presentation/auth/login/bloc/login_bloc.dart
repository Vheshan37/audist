import 'package:audist/core/exception/login_exception.dart';
import 'package:audist/data/auth/datasource/firebase_auth_service.dart';
import 'package:audist/data/auth/models/user_login_model.dart';
import 'package:audist/domain/auth/use_cases/login_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<RequestLogin>((event, emit) async {
      emit(LoginLoading());

      // try, catch process to firebase login
      try {
        // create model from event
        final loginParams = UserLoginModel(
          email: event.email,
          password: event.password,
        );

        // call service
        final response = await sl<LoginUseCase>().call(params: loginParams);

        if (response.statusCode == 200) {
          emit(
            LoginSuccess(
              message: response.message,
              userId: response.userId,
              email: response.email,
            ),
          );
        } else {
          emit(LoginFailed(message: response.message));
        }
      } catch (e) {
        emit(LoginFailed(message: "Unexpected error: $e"));
      }
    });
  }
}
