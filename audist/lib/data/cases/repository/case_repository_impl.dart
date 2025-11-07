import 'package:audist/data/cases/datasource/case_datasource.dart';
import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class CaseRepositoryImpl extends CaseRepository {
  @override
  Future<Either> fetchAllCases(FetchCaseRequest request) async {
    return await sl<CaseDatasource>().fetchAllCases(request);
  }
}
