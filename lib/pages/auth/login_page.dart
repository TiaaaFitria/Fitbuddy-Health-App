// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_buddy/widgets/gradient_background.dart';
import '../../model/app_state.dart';
import '../../model/user_preferences.dart';
import '../../model/user_model.dart';
import '../main/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailOrUserController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailOrUserController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final input = _emailOrUserController.text.trim();
      final password = _passwordController.text.trim();

      // ✅ Login otomatis jika input "admin" (tanpa password)
      if (input.toLowerCase() == 'admin') {
        currentUser = UserModel(
          id: 'admin001',
          name: 'Admin',
          email: 'admin@fitbuddy.com',
          password: '',
          role: 'admin',
        );

        await UserPreferences.saveUser(currentUser!);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: currentUser!)),
        );
        return;
      }

      // ✅ Login untuk user biasa
      if (registeredUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Belum ada akun. Silakan Register dulu.")),
        );
        return;
      }

      if ((input == registeredUser!.email || input == registeredUser!.name) &&
          password == registeredUser!.password) {
        currentUser = registeredUser;

        await UserPreferences.saveUser(currentUser!);

        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: currentUser!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email/Username atau Password salah.")),
        );
      }
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  bool _isValidUsername(String value) => RegExp(r'^[a-zA-Z]+$').hasMatch(value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- Background gradient Blue Modern (Mirip Splash Screen) ---
      body: GradientBackground(
        applySafeArea: false,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // --- Logo ---
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white.withOpacity(0.5), // Efek glow putih halus
                          blurRadius: 30,
                          spreadRadius: 3,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Image.asset("assets/logo.png", height: 120),
                  ),
                  const SizedBox(height: 24),
                  // --- Title ---
                  const Text(
                    "Fitbuddy healt!",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: Offset(1, 1),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // --- Email/Username TextField ---
                  TextFormField(
                    controller: _emailOrUserController,
                    style: const TextStyle(color: Color(0xFF4A90E2)), // Warna teks input
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                      labelText: "Email atau Username",
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.person, color: Color(0xFF4A90E2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2), // Fokus border
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kolom ini tidak boleh kosong";
                      }
                      if (value.toLowerCase() == 'admin') {
                        return null;
                      }
                      if (value.contains('@')) {
                        if (!_isValidEmail(value)) {
                          return "Format email tidak valid";
                        }
                      } else {
                        if (!_isValidUsername(value)) {
                          return "Username hanya boleh huruf tanpa angka/simbol";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // --- Password TextField ---
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Color(0xFF4A90E2)), // Warna teks input
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.95),
                      labelText: "Password",
                      labelStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF4A90E2)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          color: const Color(0xFF4A90E2),
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (_emailOrUserController.text.toLowerCase() == 'admin') {
                        return null;
                      }
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  // --- Login Button ---
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.black.withOpacity(0.6),
                      elevation: 10,
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFF9A825),
                            Color(0xFFFFC107)
                          ],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                        constraints: const BoxConstraints(minWidth: 150.0, minHeight: 48.0),
                        alignment: Alignment.center,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.login, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- Register Text ---
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "Don’t have an account? Register",
                      style: TextStyle(
                        color: Colors.white70,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
