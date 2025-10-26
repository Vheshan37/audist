import 'dart:math';

class User {
  final String date;
  final String description;
  final String payment;
  final String balance;

  User({
    required this.date,
    required this.description,
    required this.payment,
    required this.balance,
  });
}

class UserCollection {
  final List<User> users = [];

  UserCollection() {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      // Generate random date in 2022–2025 range
      int year = 2022 + random.nextInt(4);
      int month = 1 + random.nextInt(12);
      int day = 1 + random.nextInt(28);

      final List<String> months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];

      // String date =
      //     "$year-${months[month - 1].toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

      String date =
          "${months[month - 1].toString().padLeft(2, '0')} ${day.toString().padLeft(2, '0')}, $year";

      // Random description
      String description =
          "Case description asdasds asd asda  ass #${1000 + random.nextInt(9000)}";

      // Random payment and balance (formatted as Rs. XX.XX)
      double paymentValue = random.nextDouble() * 10000;
      double balanceValue = random.nextDouble() * 5000;

      String payment = "Rs. ${paymentValue.toStringAsFixed(2)}";
      String balance = "Rs. ${balanceValue.toStringAsFixed(2)}";

      users.add(
        User(
          date: date,
          description: description,
          payment: payment,
          balance: balance,
        ),
      );
    }
  }
}
