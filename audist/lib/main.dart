import 'package:audist/core/navigation/app_navigator.dart';
import 'package:audist/core/navigation/app_routes.dart';
import 'package:audist/core/string.dart';
import 'package:audist/firebase_options.dart';
import 'package:audist/presentation/auth/login/bloc/login_bloc.dart';
import 'package:audist/presentation/cases/add_new_case/blocs/add_case/add_case_bloc.dart';
import 'package:audist/presentation/cases/case_information/blocs/details/case_information_detail_bloc.dart';
import 'package:audist/presentation/cases/case_information/blocs/update/case_information_update_bloc.dart';
import 'package:audist/presentation/home/blocs/allcase/all_case_bloc.dart';
import 'package:audist/presentation/home/blocs/cases/fetch_case_bloc.dart';
import 'package:audist/presentation/payments/add_payment/blocs/add_payment/add_payment_bloc.dart';
import 'package:audist/presentation/payments/add_payment/blocs/fetch_payment/fetch_payment_bloc.dart';
import 'package:audist/presentation/splash/bloc/authorization_bloc.dart';
import 'package:audist/presentation/splash/pages/splash_screen.dart';
import 'package:audist/providers/case_filter_provider.dart';
import 'package:audist/providers/case_information_checkbox_provider.dart';
import 'package:audist/providers/case_information_provider.dart';
import 'package:audist/providers/common_data_provider.dart';
import 'package:audist/providers/image_picker_provider.dart';
import 'package:audist/providers/language_provider.dart';
import 'package:audist/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDependencies();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LanguageProvider()..getLocalSavedLanguage(),
        ),
        ChangeNotifierProvider(create: (context) => ImagePickerProvider()),
        ChangeNotifierProvider(
          create: (context) => CaseInformationCheckboxProvider(),
        ),
        ChangeNotifierProvider(create: (context) => CaseFilterProvider()),
        ChangeNotifierProvider(create: (context) => CommonDataProvider()),
        ChangeNotifierProvider(create: (context) => CaseInformationProvider()),
      ],
      child: GestureDetector(
        onLongPress: () {
          _toggleLanguage();
        },
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => LoginBloc()),
            BlocProvider(create: (context) => AuthorizationBloc()),
            BlocProvider(create: (context) => FetchCaseBloc()),
            BlocProvider(create: (context) => AllCaseBloc()),
            BlocProvider(create: (context) => AddCaseBloc()),
            BlocProvider(create: (context) => CaseInformationUpdateBloc()),
            BlocProvider(create: (context) => CaseInformationDetailBloc()),
            BlocProvider(create: (context) => AddPaymentBloc()),
            BlocProvider(create: (context) => FetchPaymentBloc()),
          ],
          child: const MyApp(),
        ),
      ),
    ),
  );
}

void _toggleLanguage() {
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Future.microtask(() {
    //   BlocProvider.of<FetchCaseBloc>(context).add(RequestFetchCase());
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageProvider>(
      builder: (context, languageProvider, child) {
        Strings.initialize(languageProvider);

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: AppNavigator.navigatorKey,
          routes: AppRoutes.routes,
          initialRoute: AppRoutes.splash,
          // home: SplashScreen(),
        );
      },
    );
  }
}
