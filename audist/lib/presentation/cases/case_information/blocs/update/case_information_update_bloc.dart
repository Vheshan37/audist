import 'package:audist/core/model/case_information/case_information_request_model.dart';
import 'package:audist/domain/cases/usecase/update_case_information_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'case_information_update_event.dart';
part 'case_information_update_state.dart';

class CaseInformationUpdateBloc
    extends Bloc<CaseInformationUpdateEvent, CaseInformationUpdateState> {
  CaseInformationUpdateBloc() : super(CaseInformationUpdateInitial()) {
    on<RequestCaseInformationUpdate>((event, emit) async {
      emit(CaseInformationUpdateLoading());

      final response = await sl<UpdateCaseInformationUseCase>().call(
        request: event.request,
      );

      response.fold(
        ((err) {
          emit(CaseInformationUpdateFailed(message: err.message));
        }),
        ((data) {
          emit(CaseInformationUpdateSuccess());
        }),
      );
    });
  }
}
