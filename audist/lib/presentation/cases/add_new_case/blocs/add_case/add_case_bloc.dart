import 'package:audist/core/exception/add_case_exception.dart';
import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/domain/cases/usecase/add_new_case_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

part 'add_case_event.dart';
part 'add_case_state.dart';

class AddCaseBloc extends Bloc<AddCaseEvent, AddCaseState> {
  AddCaseBloc() : super(AddCaseInitial()) {
    on<RequestAddCaseEvent>((event, emit) async {
      emit(AddCaseLoading());

      debugPrint("===========(Add New Case BLoC /Start)=============");
      final AddNewCaseRequestModel addNewCaseRequestModel =
          AddNewCaseRequestModel(
            refereeNum: event.refereeNo,
            caseNumb: event.caseId,
            name: event.name,
            organization: event.organization,
            value: event.value,
            caseDate: event.date,
            image: event.image,
            nic: event.nic,
            userId: event.userId,
          );

      final response = await sl<AddNewCaseUsecase>().call(
        request: addNewCaseRequestModel,
      );

      response.fold(
        (err) {
          if (err is AddCaseException) {
            emit(AddCaseFailed(errorMessage: err.errorMessage, code: err.code));
          } else {
            emit(AddCaseFailed(errorMessage: err.toString()));
          }
        },
        (data) {
          AddCaseLoaded();
        },
      );

      debugPrint("Response: $response");

      debugPrint("===========(Add New Case BLoC /End)=============");
    });
  }
}
