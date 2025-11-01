import 'package:audist/data/auth/models/user_login_model.dart';

abstract class AuthRepository {
  Future<void> login(UserLoginModel params);
}
