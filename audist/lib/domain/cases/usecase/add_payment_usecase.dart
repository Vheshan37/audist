import 'package:audist/core/exception/add_payment_exception.dart';
import 'package:audist/core/model/add_payment/add_payment_request_model.dart';
import 'package:audist/core/model/add_payment/add_payment_response_model.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/service_locator.dart';
import 'package:either_dart/either.dart';

class AddPaymentUsecase {
  Future<Either<AddPaymentException, AddPaymentResponseModel>> call({
    required AddPaymentRequestModel request,
  }) async {
    return await sl<CaseRepository>().addPayment(request);
  }
}
