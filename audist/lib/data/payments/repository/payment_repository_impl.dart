import 'package:audist/data/payments/datesource/payment_datesource.dart';
import 'package:audist/domain/payments/repository/payment_repository.dart';
import 'package:audist/service_locator.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  @override
  Future<String> downloadLedger(String caseId, String userID) async {
    return await sl<PaymentDataSource>().downloadLedger(caseId, userID);
  }
}
