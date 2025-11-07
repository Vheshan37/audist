import 'package:audist/data/cases/model/fetch_case_request.dart';
import 'package:either_dart/either.dart';

abstract class CaseRepository {
  Future<Either> fetchAllCases(FetchCaseRequest request);
}
