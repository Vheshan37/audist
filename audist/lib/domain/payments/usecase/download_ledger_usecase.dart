import 'package:audist/domain/payments/repository/payment_repository.dart';
import 'package:audist/service_locator.dart';

class DownloadLedgerUseCase {
  Future<String> call(String caseId, String userID) async {
    return await sl<PaymentRepository>().downloadLedger(caseId, userID);
  }
}
