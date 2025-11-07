part of 'fetch_case_bloc.dart';

abstract class FetchCaseState {}

class FetchCaseInitial extends FetchCaseState {}

class FetchCaseLoading extends FetchCaseState {}

class FetchCaseLoaded extends FetchCaseState {
  final List<CaseEntity> caseList;
  final int? todayCount;
  final int? totalCount;

  FetchCaseLoaded({required this.caseList, this.todayCount, this.totalCount});
}

class FetchCaseFailed extends FetchCaseState {
  final String message;

  FetchCaseFailed(this.message);
}
