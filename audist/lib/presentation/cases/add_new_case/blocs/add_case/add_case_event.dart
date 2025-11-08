part of 'add_case_bloc.dart';

abstract class AddCaseEvent {}

class RequestAddCaseEvent extends AddCaseEvent {
  final String refereeNo;
  final String caseId;
  final String name;
  final String nic;
  final String organization;
  final String value;
  final String date;
  final String userId;
  final String image;

  RequestAddCaseEvent({
    required this.refereeNo,
    required this.caseId,
    required this.name,
    required this.nic,
    required this.organization,
    required this.value,
    required this.date,
    required this.userId,
    required this.image
  });
}
