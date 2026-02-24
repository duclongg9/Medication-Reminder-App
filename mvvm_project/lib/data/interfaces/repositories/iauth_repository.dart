import 'package:mvvm_project/domain/entities/auth_session.dart';

abstract class IAuthRepository {
  Future<AuthSession> login(String userName, String password);
  Future<void> logout();
}

