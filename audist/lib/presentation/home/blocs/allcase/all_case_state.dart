part of 'all_case_bloc.dart';

abstract class AllCaseState {}

class AllCaseInitial extends AllCaseState {}

class AllCaseLoading extends AllCaseState {}

class AllCaseLoaded extends AllCaseState {
  final AllCaseModel allCaseModel;
  AllCaseLoaded({required this.allCaseModel});
}

class AllCaseFailed extends AllCaseState {
  // final int code;
  final String message;
  AllCaseFailed({required this.message});
}
