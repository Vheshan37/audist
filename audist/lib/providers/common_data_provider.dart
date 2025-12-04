import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:flutter/widgets.dart';

class CommonDataProvider extends ChangeNotifier {
  late String? uid;
  late List<CaseEntity>? list;

  void saveUser(String value) {
    uid = value;
    notifyListeners();
  }

  void modifyCaseList(List<CaseEntity> value) {
    list = value;
    notifyListeners();
  }
}
