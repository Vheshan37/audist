abstract class PaymentRepository {
  Future<String> downloadLedger(String caseId, String userID);
}