part of 'fetch_case_bloc.dart';

abstract class FetchCaseEvent {}

class RequestFetchCase extends FetchCaseEvent {
  final String uid;
  RequestFetchCase({required this.uid});
}

class FilterCasesByDate extends FetchCaseEvent {
  final DateTime selectedDate;
  final List<CaseEntity> list;
  FilterCasesByDate({required this.selectedDate, required this.list});
}
