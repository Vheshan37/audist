part of 'filter_next_case_bloc.dart';

abstract class FilterNextCaseState {}

class FilterNextCaseInitial extends FilterNextCaseState {}

class FilterNextCaseLoading extends FilterNextCaseState {}

class FilterNextCaseLoaded extends FilterNextCaseState {
  final List<CaseEntity> caseList;
  final DateTime date;
  FilterNextCaseLoaded({required this.caseList, required this.date});
}

class ResetFilterNextCase extends FilterNextCaseState {
  final List<CaseEntity> caseList;
  ResetFilterNextCase({required this.caseList});
}

class FilterNextCaseFailed extends FilterNextCaseState {}
