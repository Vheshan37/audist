import 'package:flutter/cupertino.dart';

class CaseInformationCheckboxProvider extends ChangeNotifier {
  final Map<int, Map<String, bool>> _checkboxGroups = {
    1: {'summon': false, 'newAddress': false, 'warrant': false},
    2: {'summon': false, 'newAddress': false, 'warrant': false},
    3: {'summon': false, 'newAddress': false, 'warrant': false},
  };

  bool withdraw = false;
  bool testimony = false;
  void toggleWithdraw() {
    withdraw = !withdraw;
    notifyListeners();
  }

  void toggleTestimony() {
    testimony = !testimony;
    notifyListeners();
  }

  bool getValue(int index, String type) =>
      _checkboxGroups[index]?[type] ?? false;

  void toggle(int index, String type) {
    final group = _checkboxGroups[index];
    if (group == null) return;

    // turn on the selected checkbox
    group.updateAll((k, v) => k == type);
    notifyListeners();
  }

  String getSelectedType(int index) {
    final group = _checkboxGroups[index];
    if (group == null) return "None";

    final selected = group.entries.firstWhere(
      (entry) => entry.value == true,
      orElse: () => const MapEntry("None", false),
    );
    return selected.key;
  }

  Map<String, String> getAllSelectedStatuses() {
    return {
      'person1': getSelectedType(1),
      'person2': getSelectedType(2),
      'person3': getSelectedType(3),
    };
  }

  void setStatus(int index, String? type) {
    if (type == null) return;
    final group = _checkboxGroups[index];
    if (group == null) return;

    group.updateAll((k, v) => k == type);
    notifyListeners();
  }

  void setWithdraw(bool value) {
    withdraw = value;
    notifyListeners();
  }

  void setTestimony(bool value) {
    testimony = value;
    notifyListeners();
  }
}
