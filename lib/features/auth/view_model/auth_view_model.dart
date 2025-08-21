import 'package:flutter/foundation.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repo;
  AuthViewModel(this._repo);

  bool isLoading = false;
  String? error;

  Future<bool> checkSession() async => _repo.isLoggedIn;

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      error = "Please enter both email and password";
      notifyListeners();
      return false;
    }
    try {
      isLoading = true; error = null; notifyListeners();
      final ok = await _repo.signIn(email, password);
      if (!ok) error = "Login failed. Please try again.";
      return ok;
    } catch (e) {
      error = e.toString(); return false;
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      error = "Please enter both email and password";
      notifyListeners();
      return false;
    }
    try {
      isLoading = true; error = null; notifyListeners();
      final ok = await _repo.signUp(email, password);
      if (!ok) error = "Signup failed. Please try again.";
      return ok;
    } catch (e) {
      error = e.toString(); return false;
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<void> signOut() => _repo.signOut();
}
