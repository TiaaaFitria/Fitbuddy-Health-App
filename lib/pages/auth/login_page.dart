import 'package:flutter/material.dart';
import '../../widgets/gradient_background.dart';
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
      if (registeredUser == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Belum ada akun. Silakan Register dulu.")),
        );
        return;
      }

      final input = _emailOrUserController.text.trim();
      final password = _passwordController.text.trim();

      if ((input == registeredUser!.email || input == registeredUser!.name) &&
          password == registeredUser!.password) {
        currentUser = registeredUser;

        // Simpan user ke SharedPreferences
        await UserPreferences.saveUser(currentUser!);

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // ✅ perbaikan: hanya pakai user
            builder: (context) => HomePage(user: currentUser!),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Email/Username atau Password salah.")),
        );
      }
    }
  }

  void _loginAsAdmin() async {
    currentUser = UserModel(
      id: 'admin001',
      name: 'Admin',
      email: 'admin@fitbuddy.com',
      password: 'admin123', // tidak digunakan, hanya placeholder
      role: 'admin',
    );

    await UserPreferences.saveUser(currentUser!);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        // ✅ perbaikan: hanya pakai user
        builder: (context) => HomePage(user: currentUser!),
      ),
    );
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value);
  bool _isValidUsername(String value) =>
      RegExp(r'^[a-zA-Z]+$').hasMatch(value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Image.asset("assets/logo.png", height: 120),
                  const SizedBox(height: 30),
                  const Text(
                    "FitBuddy Health",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Email/Username
                  TextFormField(
                    controller: _emailOrUserController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      labelText: "Email atau Username",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kolom ini tidak boleh kosong";
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

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      labelText: "Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password minimal 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 100,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/register'),
                    child: const Text(
                      "Don’t have an account? Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),

                  // 🔐 Tombol Login Admin
                  TextButton(
                    onPressed: _loginAsAdmin,
                    child: const Text(
                      "🔐 Login sebagai Admin",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
