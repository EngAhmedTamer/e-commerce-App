import 'package:flutter/material.dart';
import '../../items/view/home_page.dart';

import '../repository/auth_repository.dart';
import '../view_model/auth_view_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  late final AuthViewModel _authVM = AuthViewModel(AuthRepository());

  Future<void> signInWithEmail() async {
    final ok = await _authVM.signIn(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login successful!")));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_authVM.error ?? "Login failed. Please try again.")));
    }
  }

  Future<void> signUpWithEmail() async {
    final ok = await _authVM.signUp(
      emailController.text.trim(),
      passwordController.text.trim(),
    );
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Signup successful! Please check your email.")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_authVM.error ?? "Signup failed. Please try again.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff6D0EB5), Color(0xff4059F1)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                const Icon(Icons.lock_outline, size: 80, color: Colors.white),
                SizedBox(height: 20),
                Text(
                    "Welcome Back!",
                    style: TextStyle( fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.9),
                        fontStyle: FontStyle.italic)
                ),
                SizedBox(height: 30),
                _buildTextField(
                  controller: emailController,
                  hint: 'Email',
                  icon: Icons.email,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  controller: passwordController,
                  hint: 'Password',
                  icon: Icons.lock,
                  obscure: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xff4059F1),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: signUpWithEmail,
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
