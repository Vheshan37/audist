import 'package:flutter/foundation.dart';

class PaymentInformationProvider extends ChangeNotifier {
  String? _caseID;
  String? _caseName;
  String? _caseOrganization;
  String? _caseValue;
  String? _paidAmount;
  String? _dueAmount;

  String? get caseID => _caseID;
  String? get caseName => _caseName;
  String? get caseOrganization => _caseOrganization;
  String? get caseValue => _caseValue;
  String? get paidAmount => _paidAmount;
  String? get dueAmount => _dueAmount;

  void setPaidAmount(String? value) {
    _paidAmount = value;
    notifyListeners();
  }

  void setDueAmount(String? value) {
    _dueAmount = value;
    notifyListeners();
  }

  void setCaseName(String? value) {
    _caseName = value;
    notifyListeners();
  }

  void setCaseID(String? value) {
    _caseID = value;
    notifyListeners();
  }

  void setCaseOrganization(String? value) {
    _caseOrganization = value;
    notifyListeners();
  }

  void setCaseValue(String? value) {
    _caseValue = value;
    notifyListeners();
  }

  void clear() {
    _caseName = null;
    _caseID = null;
    _caseOrganization = null;
    _caseValue = null;
    notifyListeners();
  }
}
