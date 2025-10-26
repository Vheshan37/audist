import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider extends ChangeNotifier {
  bool isEnglish = true;

  void toggleLanguage() {
    isEnglish = !isEnglish;
    debugPrint("Language changed to: ${isEnglish ? 'English' : 'Sinhala'}");
    saveLanguageToLocal();
    notifyListeners();
  }

  void changeLanguage(bool language) {
    isEnglish = language;
    debugPrint("Language changed to: ${isEnglish ? 'English' : 'Sinhala'}");
    saveLanguageToLocal();
    notifyListeners();
  }

  void getLocalSavedLanguage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool? savedLanguage = prefs.getBool('isEnglish');
    if (savedLanguage != null) {
      isEnglish = savedLanguage;
      debugPrint(
        "Local saved language loaded: ${savedLanguage ? 'English' : 'Sinhala'}",
      );
      notifyListeners();
    } else {
      isEnglish = true;
      debugPrint("No local saved language found. Defaulting to English.");
      notifyListeners();
    }
  }

  Future<void> saveLanguageToLocal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isEnglish', isEnglish);
    debugPrint(
      "Language preference saved locally: ${isEnglish ? 'English' : 'Sinhala'}",
    );
  }
}
