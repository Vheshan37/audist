import 'package:audist/domain/cases/entities/case_entity.dart';
import 'package:flutter/widgets.dart';

class CommonDataProvider extends ChangeNotifier {
  late String? uid;
  late List<CaseEntity>? list = [];
  late int? todayCount = 0;
  late int? totalCount = 0;

  void saveUser(String value) {
    uid = value;
    notifyListeners();
  }

  void modifyCaseList({
    required List<CaseEntity> value,
    required int today,
    required int total,
  }) {
    list = value;
    todayCount = today;
    totalCount = total;
    debugPrint(
      "CommonDataProvider - modifyCaseList called with ${list?.length} cases",
    );
    notifyListeners();
  }
}
