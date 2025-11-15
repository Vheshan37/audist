import 'package:audist/core/exception/fetch_case_payment_exception.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_request.dart';
import 'package:audist/core/model/fetch_payment/fetch_payment_response.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class FetchCasePaymentUsecase {
  Future<Either<FetchCasePaymentException, FetchPaymentResponse>> call(
    FetchPaymentRequest request,
  ) async {
    return await sl<CaseRepository>().fetchCasePayments(request);
  }
}
