part of 'case_information_update_bloc.dart';

abstract class CaseInformationUpdateState {}

final class CaseInformationUpdateInitial extends CaseInformationUpdateState {}

final class CaseInformationUpdateLoading extends CaseInformationUpdateState {}

final class CaseInformationUpdateSuccess extends CaseInformationUpdateState {}

final class CaseInformationUpdateFailed extends CaseInformationUpdateState {
  final String message;

  CaseInformationUpdateFailed({required this.message});
}
