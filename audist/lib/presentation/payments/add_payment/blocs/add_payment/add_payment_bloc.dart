import 'package:audist/core/model/add_payment/add_payment_request_model.dart';
import 'package:audist/core/model/add_payment/add_payment_response_model.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/domain/cases/usecase/add_payment_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'add_payment_event.dart';
part 'add_payment_state.dart';

class AddPaymentBloc extends Bloc<AddPaymentEvent, AddPaymentState> {
  AddPaymentBloc() : super(AddPaymentInitial()) {
    on<RequestAddPayment>((event, emit) async {
      emit(AddPaymentLoading());

      final response = await sl<AddPaymentUsecase>().call(
        request: event.request,
      );

      response.fold(
        ((error) {
          emit(AddPaymentFailed(message: error.message));
        }),
        ((data) {
          emit(AddPaymentSuccess(response: data));
        }),
      );
    });
  }
}
