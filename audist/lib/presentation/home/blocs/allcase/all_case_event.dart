part of 'all_case_bloc.dart';

abstract class AllCaseEvent {}

class RequestAllCase extends AllCaseEvent {
  final String uid;
  RequestAllCase({required this.uid});
}
