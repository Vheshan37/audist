import 'package:audist/data/auth/datasource/firebase_auth_service.dart';
import 'package:audist/data/auth/repository/auth_repository_impl.dart';
import 'package:audist/data/cases/datasource/case_datasource.dart';
import 'package:audist/data/cases/repository/case_repository_impl.dart';
import 'package:audist/data/payments/datesource/payment_datesource.dart';
import 'package:audist/data/payments/repository/payment_repository_impl.dart';
import 'package:audist/domain/auth/repository/auth_repository.dart';
import 'package:audist/domain/auth/use_cases/login_usecase.dart';
import 'package:audist/domain/cases/repository/case_repository.dart';
import 'package:audist/domain/cases/usecase/add_new_case_usecase.dart';
import 'package:audist/domain/cases/usecase/add_payment_usecase.dart';
import 'package:audist/domain/cases/usecase/fetch_all_case_usecase.dart';
import 'package:audist/domain/cases/usecase/fetch_all_kind_cases_usecase.dart';
import 'package:audist/domain/cases/usecase/fetch_case_information_usecase.dart';
import 'package:audist/domain/cases/usecase/fetch_case_payment_usecase.dart';
import 'package:audist/domain/cases/usecase/update_case_information_usecase.dart';
import 'package:audist/domain/payments/repository/payment_repository.dart';
import 'package:audist/domain/payments/usecase/download_ledger_usecase.dart';
import 'package:audist/providers/case_information_provider.dart';
import 'package:audist/providers/payment_information_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // services/ data sources
  sl.registerSingleton<FirebaseAuthService>(FirebaseAuthServiceImpl());
  sl.registerSingleton<CaseDatasource>(CaseDatasourceImpl());
  sl.registerSingleton<PaymentDataSource>(PaymentDataSourceImpl());

  // repositories
  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<CaseRepository>(CaseRepositoryImpl());
  sl.registerSingleton<PaymentRepository>(PaymentRepositoryImpl());

  // use cases
  sl.registerSingleton<LoginUseCase>(LoginUseCase());
  sl.registerSingleton<FetchAllCases>(FetchAllCases());
  sl.registerSingleton<FetchAllKindCaseUseCase>(FetchAllKindCaseUseCase());
  sl.registerSingleton<AddNewCaseUsecase>(AddNewCaseUsecase());
  sl.registerSingleton<UpdateCaseInformationUseCase>(
    UpdateCaseInformationUseCase(),
  );
  sl.registerSingleton<FetchCaseInformationUseCase>(
    FetchCaseInformationUseCase(),
  );
  sl.registerSingleton<AddPaymentUsecase>(AddPaymentUsecase());
  sl.registerSingleton<FetchCasePaymentUsecase>(FetchCasePaymentUsecase());
  sl.registerSingleton<DownloadLedgerUseCase>(DownloadLedgerUseCase());

  // providers
  sl.registerSingleton<CaseInformationProvider>(CaseInformationProvider());
  sl.registerSingleton<PaymentInformationProvider>(
    PaymentInformationProvider(),
  );
}
