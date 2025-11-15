part of 'case_information_update_bloc.dart';

abstract class CaseInformationUpdateEvent {}

class RequestCaseInformationUpdate extends CaseInformationUpdateEvent {
  final CaseInformationRequestModel request;
  RequestCaseInformationUpdate({required this.request});
}
