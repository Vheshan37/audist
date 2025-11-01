import 'package:flutter/cupertino.dart';

class CaseInformationCheckboxProvider extends ChangeNotifier {
  final Map<int, Map<String, bool>> _checkboxGroups = {
    1: {'summon': false, 'newAddress': false, 'warrant': false},
    2: {'summon': false, 'newAddress': false, 'warrant': false},
    3: {'summon': false, 'newAddress': false, 'warrant': false},
  };

  bool getValue(int index, String type) =>
      _checkboxGroups[index]?[type] ?? false;

  void toggle(int index, String type) {
    final group = _checkboxGroups[index];
    if (group == null) return;

    // turn on the selected checkbox
    group.updateAll((k, v) => k == type);
    notifyListeners();
  }
}
