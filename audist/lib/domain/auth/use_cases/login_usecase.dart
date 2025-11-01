import 'package:audist/data/auth/models/user_login_model.dart';
import 'package:audist/domain/auth/repository/auth_repository.dart';
import 'package:audist/service_locator.dart';

class LoginUseCase {
  Future<void> call({required UserLoginModel params}) async {
    return await sl<AuthRepository>().login(params);
  }
}
