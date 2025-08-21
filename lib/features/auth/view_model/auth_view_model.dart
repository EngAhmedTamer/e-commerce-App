import 'package:flutter/foundation.dart';
import 'package:ecommerce/core/usecase/usecase.dart';
import '../../auth/domain/usecases/authenticate_user_usecase.dart';
import '../../auth/domain/usecases/check_auth_status_usecase.dart';
import '../../auth/domain/usecases/signup_user_usecase.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthenticateUserUseCase authenticateUserUseCase;
  final SignupUserUseCase signupUserUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  AuthViewModel({
    required this.authenticateUserUseCase,
    required this.signupUserUseCase,
    required this.checkAuthStatusUseCase,
  });

  bool isLoading = false;
  String? error;

  Future<bool> checkSession() async => await checkAuthStatusUseCase(const NoParams());

  Future<bool> signIn(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      error = "Please enter both email and password";
      notifyListeners();
      return false;
    }
    try {
      isLoading = true; error = null; notifyListeners();
      await authenticateUserUseCase(AuthParams(email, password));
      return true;
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
      await signupUserUseCase(SignUpParams(email, password));
      return true;
    } catch (e) {
      error = e.toString(); return false;
    } finally {
      isLoading = false; notifyListeners();
    }
  }

  Future<void> signOut() async {
    // Could add a LogoutUseCase if needed. For now, use Supabase directly via DI or extend repository later.
  }
}
