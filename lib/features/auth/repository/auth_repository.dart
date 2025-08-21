import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _client = Supabase.instance.client;

  bool get isLoggedIn => _client.auth.currentUser != null;

  Future<bool> signIn(String email, String password) async {
    final res = await _client.auth.signInWithPassword(email: email, password: password);
    return res.session != null;
  }

  Future<bool> signUp(String email, String password) async {
    final res = await _client.auth.signUp(email: email, password: password);
    return res.user != null;
  }

  Future<void> signOut() => _client.auth.signOut();
}
