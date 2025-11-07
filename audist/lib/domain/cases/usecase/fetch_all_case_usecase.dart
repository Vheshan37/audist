import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class FetchAllCases {
  Future<Either> call({required FetchCaseRequest request}) async {
    return await sl<CaseRepository>().fetchAllCases(request);
  }
}
