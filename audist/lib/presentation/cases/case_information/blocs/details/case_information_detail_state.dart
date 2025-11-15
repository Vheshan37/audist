part of 'case_information_detail_bloc.dart';

abstract class CaseInformationDetailState {}

class CaseInformationDetailInitial extends CaseInformationDetailState {}

class CaseInformationDetailLoading extends CaseInformationDetailState {}

class CaseInformationDetailLoaded extends CaseInformationDetailState {}

class CaseInformationDetailSuccess extends CaseInformationDetailState {
  final CaseInformationResponseModel response;
  CaseInformationDetailSuccess({required this.response});
}

class CaseInformationDetailFailed extends CaseInformationDetailState {}
