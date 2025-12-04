part of 'fetch_case_bloc.dart';

abstract class FetchCaseEvent {}

class RequestFetchCase extends FetchCaseEvent {
  final String uid;
  RequestFetchCase({required this.uid});
}

// class LoadFullCases extends FetchCaseEvent {
//   final List<CaseEntity>? caseList;
//   final int? todayCount;
//   final int? totalCount;
//
//   LoadFullCases({
//     required this.caseList,
//     required this.todayCount,
//     required this.totalCount,
//   });
// }
