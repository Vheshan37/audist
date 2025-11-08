import 'package:audist/data/auth/datasource/firebase_auth_service.dart';
import 'package:audist/data/auth/repository/auth_repository_impl.dart';
import 'package:audist/data/cases/datasource/case_datasource.dart';
import 'package:audist/data/cases/repository/case_repository_impl.dart';
import 'package:audist/domain/auth/repository/auth_repository.dart';
import 'package:audist/domain/auth/use_cases/login_usecase.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/domain/cases/usecase/fetch_all_case_usecase.dart';
import 'package:audist/domain/cases/usecase/fetch_all_kind_cases_usecase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // services
  sl.registerSingleton<FirebaseAuthService>(FirebaseAuthServiceImpl());
  sl.registerSingleton<CaseDatasource>(CaseDatasourceImpl());

  // repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<CaseRepository>(CaseRepositoryImpl());

  // use cases
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<FetchAllCases>(FetchAllCases());
  sl.registerSingleton<FetchAllKindCaseUseCase>(FetchAllKindCaseUseCase());
  // sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());
  // sl.registerSingleton<ForgotPasswordUseCase>(ForgotPasswordUseCase());
}
