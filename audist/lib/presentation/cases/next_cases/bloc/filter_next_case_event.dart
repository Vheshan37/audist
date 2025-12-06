part of 'filter_next_case_bloc.dart';

abstract class FilterNextCaseEvent {}

class FilterCasesByDate extends FilterNextCaseEvent {
  final DateTime selectedDate;
  final List<CaseEntity> list;
  FilterCasesByDate({required this.selectedDate, required this.list});
}

class ResetFilterNextCaseEvent extends FilterNextCaseEvent {
  final List<CaseEntity> list;
  ResetFilterNextCaseEvent({required this.list});
}
