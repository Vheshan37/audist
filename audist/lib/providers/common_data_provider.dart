import 'package:flutter/widgets.dart';

class CommonDataProvider extends ChangeNotifier {
  late String? uid;

  void saveUser(String value) {
    uid = value;
    notifyListeners();
  }
}
