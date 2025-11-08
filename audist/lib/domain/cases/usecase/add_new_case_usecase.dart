import 'package:audist/core/model/add_new_case/add_new_case_request_model.dart';
import 'package:audist/data/cases/datasource/case_datasource.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class AddNewCaseUsecase {
  Future<Either> call({required AddNewCaseRequestModel request}) async{
    return await sl<CaseRepository>().addNewCase(request);
  }
}