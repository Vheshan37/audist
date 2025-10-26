import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/presentation/home/pages/home_screen.dart';
import 'package:audist/presentation/splash/pages/splash_screen.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider()..getLocalSavedLanguage(),
        ),
        ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
      ],
      child: GestureDetector(
        onLongPress: () {
          _toogleLanguage();
        },
        child: const MyApp(),
      ),
    ),
  );
}

void _toogleLanguage() {
  LanguageProvider languageProvider = Provider.of<LanguageProvider>(
    AppNavigator.navigatorKey.currentContext!,
    listen: false,
  );
  languageProvider.toggleLanguage();
  ScaffoldMessenger.of(AppNavigator.navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      content: Text(
        'Language changed to ${languageProvider.isEnglish ? 'English' : 'Sinhala'}',
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        Strings.initialize(languageProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigator.navigatorKey,
          routes: AppRoutes.routes,
          home: SplashScreen(),
        );
      },
    );
  }
}
