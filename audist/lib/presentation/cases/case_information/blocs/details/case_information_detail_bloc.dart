import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:audist/core/model/case_information/case_information_view_model.dart';
import 'package:audist/domain/cases/usecase/fetch_case_information_usecase.dart';
import 'package:audist/providers/case_information_provider.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'case_information_detail_event.dart';
part 'case_information_detail_state.dart';

class CaseInformationDetailBloc
    extends Bloc<CaseInformationDetailEvent, CaseInformationDetailState> {
  CaseInformationDetailBloc() : super(CaseInformationDetailInitial()) {
    on<RequestCaseInformationEvent>((event, emit) async {
      emit(CaseInformationDetailLoading());

      // fetch case information => UseCase
      final response = await sl<FetchCaseInformationUseCase>().call(
        event.request,
      );

      response.fold(
        ((error) {
          emit(CaseInformationDetailFailed());
        }),
        ((data) {
          debugPrint(
            "Case number: ${data.caseInformationResponseCase?.caseNumber}",
          );
          emit(CaseInformationDetailSuccess(response: data));
        }),
      );
    });
  }
}
