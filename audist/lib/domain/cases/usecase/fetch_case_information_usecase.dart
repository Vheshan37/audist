import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:audist/core/model/case_information/case_information_view_model.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class FetchCaseInformationUseCase {
  Future<Either<dynamic, CaseInformationResponseModel>> call(
    CaseInformationViewModel request,
  ) async {
    return await sl<CaseRepository>().caseInformationDetails(request);
  }
}
