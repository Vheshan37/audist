import 'package:audist/core/model/case_information/case_information_request_model.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class UpdateCaseInformationUseCase {
  Future<Either> call({required CaseInformationRequestModel request}) async {
    return await sl<CaseRepository>().caseInformationUpdate(request);
  }
}