import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filter_next_case_event.dart';
part 'filter_next_case_state.dart';

class FilterNextCaseBloc
    extends Bloc<FilterNextCaseEvent, FilterNextCaseState> {
  FilterNextCaseBloc() : super(FilterNextCaseInitial()) {
    on<FilterCasesByDate>((event, emit) async {
      emit(FilterNextCaseLoading());

      List<CaseEntity> filteredList = event.list
          .where(
            (caseItem) =>
                caseItem.caseDate?.year == event.selectedDate.year &&
                caseItem.caseDate?.month == event.selectedDate.month &&
                caseItem.caseDate?.day == event.selectedDate.day,
          )
          .toList();

      emit(
        FilterNextCaseLoaded(caseList: filteredList, date: event.selectedDate),
      );
    });
    on<ResetFilterNextCaseEvent>((event, emit) async {
      emit(ResetFilterNextCase(caseList: event.list));
    });
  }
}
