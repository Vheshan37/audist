import 'package:audist/data/auth/datasource/firebase_auth_service.dart';
import 'package:audist/data/auth/repository/auth_repository_impl.dart';
import 'package:audist/domain/auth/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // services
  sl.registerSingleton<FirebaseAuthService>(FirebaseAuthServiceImpl());

  // repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());

  // use cases
  // sl.registerSingleton<SignUpUseCase>(SignUpUseCase());
  // sl.registerSingleton<GetAgesUseCase>(GetAgesUseCase());
  // sl.registerSingleton<ForgotPasswordUseCase>(ForgotPasswordUseCase());
}
