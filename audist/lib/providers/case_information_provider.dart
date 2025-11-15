import 'package:audist/core/model/case_information/case_Information_response_model.dart';
import 'package:flutter/widgets.dart';

class CaseInformationProvider extends ChangeNotifier {
  CaseInformationResponseModel? _response;

  Future<void> setResponse(CaseInformationResponseModel response) async {
    _response = response;
    notifyListeners();
  }

  CaseInformationResponseModel? getResponse(){
    return _response;
  }

  void clearCaseinformation() {
    _response = null;
  }
}
