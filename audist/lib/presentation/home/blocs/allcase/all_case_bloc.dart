import 'package:audist/core/model/all_case_model.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:audist/domain/cases/usecase/fetch_all_kind_cases_usecase.dart';
import 'package:audist/providers/case_filter_provider.dart';
import 'package:audist/service_locator.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'all_case_event.dart';
part 'all_case_state.dart';

class AllCaseBloc extends Bloc<AllCaseEvent, AllCaseState> {
  AllCaseBloc() : super(AllCaseInitial()) {
    on<RequestAllCase>((event, emit) async {
      emit(AllCaseLoading());

      FetchCaseRequest fetchCaseRequest = FetchCaseRequest(uid: event.uid);

      final response = await sl<FetchAllKindCaseUseCase>().call(
        request: fetchCaseRequest,
      );

      response.fold(
        ((err) {
          debugPrint(
            '=====================(AllCaseBloc Error)====================',
          );
          debugPrint("Error: $err");
          debugPrint(
            '=====================(AllCaseBloc Error)====================',
          );
          emit(AllCaseFailed(message: err.toString()));
        }),
        ((data) {
          debugPrint('=====================(AllCaseBloc)====================');
          debugPrint('AllCaseBloc Full Response: $data');
          debugPrint(
            'FetchAllCase BLoC Response Pending List: ${data["pending"]}',
          );
          debugPrint(
            'FetchAllCase BLoC Response Ongoing List: ${data["ongoing"]}',
          );
          debugPrint(
            'FetchAllCase BLoC Response Complete List: ${data["complete"]}',
          );
          debugPrint(
            'FetchAllCase BLoC Response Testimony List: ${data["testimony"]}',
          );

          AllCaseModel allCaseModel = AllCaseModel.fromJson(data);

          debugPrint('FetchAllCase BLoC Response: $allCaseModel');
          debugPrint('=====================(AllCaseBloc)====================');

          emit(AllCaseLoaded(allCaseModel: allCaseModel));
        }),
      );
    });
  }
}
