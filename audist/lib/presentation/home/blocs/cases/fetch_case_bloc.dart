import 'package:audist/core/exception/fetch_case_exception.dart';
import 'package:audist/core/model/case_model.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/domain/cases/usecase/fetch_all_case_usecase.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'fetch_case_event.dart';
part 'fetch_case_state.dart';

class FetchCaseBloc extends Bloc<FetchCaseEvent, FetchCaseState> {
  FetchCaseBloc() : super(FetchCaseInitial()) {
    on<RequestFetchCase>((event, emit) async {
      emit(FetchCaseLoading());

      FetchCaseRequest requestObject = FetchCaseRequest(uid: event.uid);

      final response = await sl<FetchAllCases>().call(request: requestObject);

      // response is Either<FetchCaseException, List<CaseModel>>
      response.fold(
        (error) {
          debugPrint('Bloc Response for Fetch All Cases (Failed): $error');
          emit(FetchCaseFailed(error.toString()));
        },
        (data) {
          debugPrint('Bloc Response for Fetch All Cases (Success): $data');

          List<CaseEntity> caseList = (data["cases"] as List)
              .map((caseJson) => CaseEntity.fromJson(caseJson))
              .toList();

          emit(
            FetchCaseLoaded(
              caseList: caseList,
              todayCount: data["todayCount"],
              totalCount: data["totalCase"],
            ),
          );
        },
      );
    });
    on<FilterCasesByDate>((event, emit) async {
      emit(FetchCaseLoading());

      List<CaseEntity> filteredList = event.list
          .where(
            (caseItem) =>
                caseItem.caseDate?.year == event.selectedDate.year &&
                caseItem.caseDate?.month == event.selectedDate.month &&
                caseItem.caseDate?.day == event.selectedDate.day,
          )
          .toList();

      emit(
        FilteredCasesByDate(
          caseList: filteredList,
        ),
      );
    });
  }
}
