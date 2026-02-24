import 'package:flutter/foundation.dart';
import 'package:mvvm_project/data/interfaces/repositories/iauth_repository.dart';
import 'package:mvvm_project/domain/entities/auth_session.dart';

class LoginViewModel extends ChangeNotifier {
  final IAuthRepository repo;

  LoginViewModel(this.repo);

  bool loading = false;
  String? error;
  AuthSession? session;

  Future<bool> login(String userName, String password) async {
    loading = true;
    error = null;
    notifyListeners();

    try {
      final u = userName.trim();
      final p = password.trim();
      if (u.isEmpty || p.isEmpty) {
        throw Exception('Please enter username');
      }
      session = await repo.login(u, p);
      return true;
    } catch (e) {
      session = null;
      error = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await repo.logout();
    session = null;
    error = null;
    notifyListeners();
  }


  void clearError() {
    if (error != null) {
      error = null;
      notifyListeners();
    }
  }
}

