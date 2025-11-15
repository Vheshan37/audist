part of 'case_information_detail_bloc.dart';

abstract class CaseInformationDetailEvent {}

class RequestCaseInformationEvent extends CaseInformationDetailEvent {
  final CaseInformationViewModel request;
  RequestCaseInformationEvent({required this.request});
}
