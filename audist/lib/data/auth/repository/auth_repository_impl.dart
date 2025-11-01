import 'package:audist/data/auth/datasource/firebase_auth_service.dart';
import 'package:audist/data/auth/models/login_response_model.dart';
import 'package:audist/data/auth/models/user_login_model.dart';
import 'package:audist/domain/auth/repository/auth_repository.dart';
import 'package:audist/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<LoginResponseModel> login(UserLoginModel params) async {
    return await sl<FirebaseAuthService>().login(params);
  }
}
