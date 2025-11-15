import 'package:audist/core/model/add_payment/add_payment_request_model.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_request.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_response.dart';
import 'package:audist/domain/cases/usecase/fetch_case_payment_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'fetch_payment_event.dart';
part 'fetch_payment_state.dart';

class FetchPaymentBloc extends Bloc<FetchPaymentEvent, FetchPaymentState> {
  FetchPaymentBloc() : super(FetchPaymentInitial()) {
    on<RequestFetchPayment>((event, emit) async {
      debugPrint("RequestFetchPayment Called");
      emit(FetchPaymentLoading());

      // call use case and handle either response (left, right)
      final response = await sl<FetchCasePaymentUsecase>().call(event.request);

      response.fold(
        ((error) {
          emit(FetchPaymentFailed(message: error.errorMessage));
          debugPrint("RequestFetchPayment Failed: ${error.errorMessage}");
        }),
        ((data) {
          emit(FetchPaymentSuccess(data: data));
          debugPrint("RequestFetchPayment Success");
        }),
      );
    });
  }
}
