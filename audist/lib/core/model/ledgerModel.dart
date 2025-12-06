class PaymentHistoryModel {
  final String date;
  final String description;
  final String payment;
  final String balance;

  PaymentHistoryModel({
    required this.date,
    required this.description,
    required this.payment,
    required this.balance,
  });
}

class PaymentHistoryCollection {
  final List<PaymentHistoryModel> _users = [];

  void addUser(PaymentHistoryModel model) {
    _users.add(model);
  }

  List<PaymentHistoryModel> getCollection() {
    return _users;
  }
}
