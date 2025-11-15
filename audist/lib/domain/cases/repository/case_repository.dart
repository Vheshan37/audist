import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:audist/core/model/case_information/case_information_request_model.dart';
import 'package:audist/core/model/case_information/case_information_view_model.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:either_dart/either.dart';

abstract class CaseRepository {
  Future<Either> fetchAllCases(FetchCaseRequest request);
  Future<Either> fetchAllKindOfCases(FetchCaseRequest request);
  Future<Either> addNewCase(AddNewCaseRequestModel request);
  Future<Either> caseInformationUpdate(CaseInformationRequestModel request);
  Future<Either<dynamic, CaseInformationResponseModel>> caseInformationDetails(CaseInformationViewModel request);
}
