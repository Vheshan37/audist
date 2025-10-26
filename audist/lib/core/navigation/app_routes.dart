import 'package:audist/presentation/cases/add_new_case/pages/new_case_screen.dart';
import 'package:audist/presentation/auth/login/pages/login_screen.dart';
import 'package:audist/presentation/cases/case_history/pages/case_history_screen.dart';
import 'package:audist/presentation/cases/case_information/pages/case_information_screen.dart';
import 'package:audist/presentation/cases/next_cases/pages/next_cases_screen.dart';
import 'package:audist/presentation/home/pages/home_screen.dart';
import 'package:audist/presentation/language/pages/language_screen.dart';
import 'package:audist/presentation/payments/add_payment/pages/add_payment_screen.dart';
import 'package:audist/presentation/payments/payment_history/pages/payment_history_screen.dart';
import 'package:audist/presentation/splash/pages/splash_screen.dart';
import 'package:flutter/cupertino.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String login = '/login';
  static const String newCase = '/new-case';
  static const String caseHistory = '/case-history';
  static const String caseinformation = '/case-information';
  static const String nextCase = '/next-case';
  static const String addPayment = '/add-payment';
  static const String paymentHistory = '/payment-history';
  static const String languageChooser = '/language-chooser';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    home: (context) => const HomeScreen(),
    login: (context) => const LoginScreen(),
    newCase: (context) => const NewCaseScreen(),
    caseHistory: (context) => const CaseHistoryScreen(),
    caseinformation: (context) => const CaseInformationScreen(),
    nextCase: (context) => const NextCasesScreen(),
    addPayment: (context) => const AddPaymentScreen(),
    paymentHistory: (context) => const PaymentHistoryScreen(),
    languageChooser: (context) => const LanguageScreen(),
  };
}
