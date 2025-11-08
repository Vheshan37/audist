import 'package:audist/presentation/cases/case_history/pages/case_history_screen.dart';
import 'package:audist/providers/language_provider.dart';

class Strings {
  // private constructor to prevent instantiation
  Strings._();

  // Language provider reference
  static LanguageProvider? _languageProvider;

  // Method to initialize the language provider
  static void initialize(LanguageProvider provider) {
    _languageProvider = provider;
  }

  // Helper getter to check current language
  static bool get _isEnglish => _languageProvider?.isEnglish ?? true;

  // common strings
  static String get appName => "Audist";
  static String get copyright => "© 2025 Techknow Lanka";
  static String get appDeveloper =>
      "Developed by Techknow Lanka Engineers (Pvt) Ltd.";

  static Splash get splash => Splash();
  static Login get login => Login();
  static Home get home => Home();
  static NewCase get newCase => NewCase();
  static LanguageChooser get languageChooser => LanguageChooser();
  static AddPayment get addPayment => AddPayment();
  static Ledger get ledger => Ledger();
  static NextCase get nextCase => NextCase();
  static CaseHistory get caseHistory => CaseHistory();
  static CasePopUp get casePopUp => CasePopUp();
  static CaseInformation get caseInformation => CaseInformation();
}

class CaseInformation {
  String get title => _isEnglish ? "Case Information" : "නඩු විභාග විස්තර";
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get id => _isEnglish ? "Referee no" : "තීරක අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get organization => _isEnglish ? "Organization" : "සමිතිය";
  String get value => _isEnglish ? "Value" : "වටිනාකම";
  String get respondent => _isEnglish ? "Respondent" : "වගඋත්තරකරු";
  String get summons => _isEnglish ? "Summons" : "සිතාසි";
  String get newAddress => _isEnglish ? "New Address" : "නව ලිපිනය";
  String get warrant => _isEnglish ? "Warrants" : "වරෙන්තු";
  String get nextCaseDate => _isEnglish ? "Next Case Date" : "ඉදිරි නඩු දිනය";
  String get todaysPayment => _isEnglish ? "Today's Payment" : "අද දින ගෙවීම";
  String get installment => _isEnglish ? "Installment" : "වාරිකය";
  String get nextPayableDate => _isEnglish ? "Next Case Date" : "ඉදිරි දිනය";
  String get judgement => _isEnglish ? "Judgement" : "තීන්දුව";
  String get otherInformation => _isEnglish ? "Other Information" : "වෙනත් තොරතුරු";
  String get withdraw => _isEnglish ? "Withdraw" : "ඉල්ලා අස්කරගැනීම";
  String get testimony => _isEnglish ? "Testimony" : "බහ තැබීම";
  String get registerButtonText => _isEnglish ? "Register Case Information" : "නඩු විස්තර ඇතුලත් කරන්න";
}

class CasePopUp {
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get id => _isEnglish ? "Referee no" : "තීරක අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get organization => _isEnglish ? "Organization" : "සමිතිය";
  String get value => _isEnglish ? "Value" : "වටිනාකම";
  String get primaryButton =>
      _isEnglish ? "Register Case Information" : "විභාග විස්තර ඇතුලත් කරන්න";
  String get secondaryButton =>
      _isEnglish ? "Modify Case Date" : "දිනය යාවත්කාලීන කිරීම";
}

class CaseHistory {
  String get title => _isEnglish ? "Examined Cases" : "විභාග වූ නඩු";
  String get selectDate => _isEnglish ? "Select Date" : "දිනය තෝරන්න";
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get actionButton => _isEnglish ? "Refresh" : "යාවත් කාලීන කරන්න";
}

class NextCase {
  String get title => _isEnglish ? "Upcoming Cases" : "ඉදිරි නඩු";
  String get selectDate => _isEnglish ? "Select Date" : "දිනය තෝරන්න";
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get actionButton => _isEnglish ? "Refresh" : "යාවත් කාලීන කරන්න";
}

class Ledger {
  String get title => _isEnglish ? "Ledger" : "ලෙජරය";
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get select => _isEnglish ? "Select" : "තෝරන්න";
  String get id => _isEnglish ? "Referee no" : "තීරක අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get organization => _isEnglish ? "Organization" : "සමිතිය";
  String get value => _isEnglish ? "Value" : "වටිනාකම";
  String get date => _isEnglish ? "Date" : "දිනය";
  String get description => _isEnglish ? "Description" : "විස්තරය";
  String get payment => _isEnglish ? "Payment" : "අයවීම";
  String get balance => _isEnglish ? "Balance" : "ශේෂය";
  String get download => _isEnglish ? "Download" : "බාගත කිරීම";
}

class AddPayment {
  String get title => _isEnglish ? "Add Payment" : "මුදල් අයවීම";
  String get caseNumber => _isEnglish ? "Case Number" : "නඩු අංකය";
  String get select => _isEnglish ? "Select" : "තෝරන්න";
  String get id => _isEnglish ? "Referee no" : "තීරක අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get organization => _isEnglish ? "Organization" : "සමිතිය";
  String get value => _isEnglish ? "Value" : "වටිනාකම";
  String get paymentDate => _isEnglish ? "Payment Date" : "අයවීම් දිනය";
  String get amount => _isEnglish ? "Amount" : "අයවීම් මුදල";
  String get balance => _isEnglish ? "Balance" : "ශේෂය";
  String get other => _isEnglish ? "Other" : "වෙනත්";
  String get addButtonText =>
      _isEnglish ? "Add Payment" : "මුදල් අයවීම් එක් කරන්න";
}

class LanguageChooser {
  String get title => _isEnglish ? "Choose Language" : "භාෂාව තෝරන්න";
  String get subTitle =>
      _isEnglish ? "Select your preferred language." : "ඔබ කැමති භාෂාව තෝරන්න.";
  String get english => "English";
  String get sinhala => "සිංහල";
}

class NewCase {
  String get title => _isEnglish ? "Add New Case" : "නව නඩුවක් එක් කරන්න";
  String get id => _isEnglish ? "Referee no" : "තීරක අංකය";
  String get number => _isEnglish ? "Case number" : "නඩු අංකය";
  String get name => _isEnglish ? "Name" : "නම";
  String get nic => _isEnglish ? "NIC" : "හැදුනුම්පත් අංකය";
  String get organization => _isEnglish ? "Organization" : "සමිතිය";
  String get value => _isEnglish ? "Value" : "වටිනාකම";
  String get nextCaseDate => _isEnglish ? "Next Case Date" : "ඊළඟ නඩු දිනය";
  String get selectDate => _isEnglish ? "Select Date" : "දිනය තෝරන්න";
  String get selectImage => _isEnglish ? "Select Image" : "පින්තූරය තෝරන්න";
  String get insertModel => _isEnglish ? "Insert Model" : "ආකෘතිය ඇතුල් කරන්න";
  String get insertCase => _isEnglish ? "Insert Case" : "නඩුව ඇතුල් කරන්න";
  String get noImageSelected =>
      _isEnglish ? "No image selected." : "පින්තූරයක් තෝරා නොමැත.";
}

class Splash {
  String get title => _isEnglish
      ? "Welcome to ${Strings.appName}"
      : "${Strings.appName} වෙත සාදරයෙන් පිළිගනිමු";
  String get subTitle => _isEnglish
      ? "Manage and track your cases with ease."
      : "පහසුවෙන් ඔබේ නඩු කළමනාකරණය කර අවධානය යොමු කරන්න";
}

class Login {
  String get title => _isEnglish ? "Hello" : "ආයුබෝවන්";
  String get subTitle => _isEnglish
      ? "Sign in to manage your cases."
      : "ඔබේ නඩු කළමනාකරණය කිරීමට ප්‍රවේශ වන්න";
  String get emailHint => _isEnglish ? "Username" : "පරිශීලක නාමය";
  String get passwordHint => _isEnglish ? "Password" : "මුරපදය";
  String get buttonText => _isEnglish ? "Sign In" : "ඇතුල් වන්න";
  String get doNotHaveAccount =>
      _isEnglish ? "Don't have an account? " : "ඔබට ගිණුමක් නැද්ද? ";
  String get contactAdmin =>
      _isEnglish ? "Contact Administrator" : "පරිපාලකයා අමතන්න";
}

class Home {
  String get title => _isEnglish ? "Dashboard" : "ප්‍රධාන පුවරුව";
  String get subTitle =>
      _isEnglish ? "Welcome back" : "නැවත ඔබව සාදරයෙන් පිළිගනිමු";
  String get todayCases => _isEnglish ? "Today's Cases" : "අද දින නඩු සංඛ්‍යාව";
  String get totalCases => _isEnglish ? "Total Cases" : "සියලු නඩු සංඛ්‍යාව";
  String get menuItem1 => _isEnglish ? "Add Cases" : "නඩු ඇතුලත් කරන්න";
  String get menuItem2 =>
      _isEnglish ? "Case payment" : "මුදල් අයවීම් ඇතුලත් කරන්න";
  String get menuItem3 => _isEnglish ? "Ledger Management" : "ලෙජරය සැකසීම";
  String get menuItem4 => _isEnglish ? "All Cases" : "සියලු නඩු";
  // String get menuItem4 => _isEnglish ? "Examined Cases" : "විභාග වූ නඩු";
  String get menuItem5 => _isEnglish ? "Upcoming Cases" : "ඉදිරි නඩු";
  String get menuItem6 => _isEnglish ? "Settings" : "සැකසුම්";
}

// Helper extension to check current language
extension LocalizationHelper on Object {
  bool get _isEnglish => Strings._languageProvider?.isEnglish ?? true;
}
