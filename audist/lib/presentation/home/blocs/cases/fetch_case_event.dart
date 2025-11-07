part of 'fetch_case_bloc.dart';

abstract class FetchCaseEvent {}

class RequestFetchCase extends FetchCaseEvent {
  final String uid;
  RequestFetchCase({required this.uid});
}
