import 'package:audist/core/model/all_case_model.dart';
import 'package:flutter/material.dart';

class CaseFilterProvider extends ChangeNotifier {
  final List<Map<String, String>> _filterOptions = [
    {'eng': 'Ongoing Cases', 'sin': 'පවතින නඩු'},
    {'eng': 'Completed Cases', 'sin': 'අවසන් වූ නඩු'},
    {'eng': 'Testimony Cases', 'sin': 'බහ තැබූ නඩු'},
    {'eng': 'Withdrawn Cases', 'sin': 'ඉල්ලා අස් කළ නඩු'},
  ];

  Map<String, Map<String, String>> get caseTypeLocalized => {
    'Ongoing Cases': {'eng': 'Ongoing Case', 'sin': 'පවතින නඩුවක්'},
    'Completed Cases': {'eng': 'Completed Case', 'sin': 'අවසන් නඩුවක්'},
    'Testimony Cases': {'eng': 'Testimony Case', 'sin': 'බහ තැබූ නඩුවක්'},
    'Withdrawn Cases': {'eng': 'Withdrawn Case', 'sin': 'ඉල්ලා අස් කළ නඩුවක්'},
  };

  List<CaseObject> caseList = [];
  late AllCaseModel allCases;

  String _selectedFilter = 'Ongoing Cases';

  List<String> localizedFilterOptions(bool isEnglish) =>
      _filterOptions.map((opt) => opt[isEnglish ? 'eng' : 'sin']!).toList();

  String localizedSelectedFilter(bool isEnglish) {
    final match = _filterOptions.firstWhere(
      (opt) => opt['eng'] == _selectedFilter,
      orElse: () => _filterOptions.first,
    );
    return match[isEnglish ? 'eng' : 'sin']!;
  }

  List<Map<String, String>> get filterOptions => _filterOptions;
  String get selectedFilter => _selectedFilter;

  void saveAllCasesObject(AllCaseModel allCaseModel) {
    allCases = allCaseModel;
    debugPrint("All Case Object Saved in the CaseFilterProvider");
    setList("Ongoing Cases");
  }

  void setList(String state) {
    if (state == "Ongoing Cases") {
      caseList = allCases.ongoing;
    } else if (state == "Completed Cases") {
      caseList = allCases.complete;
    } else if (state == "Testimony Cases") {
      caseList = allCases.testimony;
    } else if (state == "Withdrawn Cases") {
      // caseList = allCases.ongoing;
      caseList = [];
    } else {
      caseList = allCases.ongoing;
    }
    debugPrint("Case List updated for state: $state");
    notifyListeners();
  }

  void setFilter(String value) {
    _selectedFilter = value;
    notifyListeners();
  }
}
