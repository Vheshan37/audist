import 'package:audist/data/auth/models/login_response_model.dart';
import 'package:audist/data/auth/models/user_login_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login(UserLoginModel params);
}
