import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:either_dart/either.dart';

abstract class CaseRepository {
  Future<Either> fetchAllCases(FetchCaseRequest request);
  Future<Either> fetchAllKindOfCases(FetchCaseRequest request);
  Future<Either> addNewCase(AddNewCaseRequestModel request);
}
