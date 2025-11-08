part of 'add_case_bloc.dart';

abstract class AddCaseState {}

class AddCaseInitial extends AddCaseState {}

class AddCaseLoading extends AddCaseState {}

class AddCaseLoaded extends AddCaseState {}

class AddCaseFailed extends AddCaseState {}
