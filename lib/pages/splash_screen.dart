
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '/model/user_preferences.dart';
import '/pages/auth/login_page.dart';
import '/pages/main/home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _waveController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Timer _bgTimer;
  int _gradientIndex = 0;

  final List<List<Color>> _gradients = [
    [const Color(0xFF64B5F6), const Color(0xFF1976D2)],
    [const Color(0xFF81D4FA), const Color(0xFF1565C0)],
    [const Color(0xFF90CAF9), const Color(0xFF0D47A1)],
    [const Color(0xFF64B5F6), const Color(0xFF42A5F5)],
  ];

  @override
  void initState() {
    super.initState();

    // 🎞️ Logo animation
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoController.forward();

    // 🌊 Wave loader animation
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 🌈 Gradient loop animation
    _bgTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (mounted) {
        setState(() {
          _gradientIndex = (_gradientIndex + 1) % _gradients.length;
        });
      }
    });

    // 🕓 Navigasi otomatis setelah 4 detik
    Timer(const Duration(seconds: 4), _navigateNext);
  }

  /// Navigasi otomatis ke halaman berikut
  Future<void> _navigateNext() async {
    try {
      final savedUser = await UserPreferences.getUser();

      if (!mounted) return;

      if (savedUser != null) {
        // ✅ Pindah ke Home tanpa ubah URL
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomePage(user: savedUser)),
        );
      } else {
        // ✅ Jika belum login, ke LoginPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      // ✅ Fallback ke LoginPage jika error
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _waveController.dispose();
    _bgTimer.cancel();
    super.dispose();
  }

  // 🌊 Wave Loader
  Widget _buildWaveLoader() {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            double value =
                sin((_waveController.value * 2 * pi) + (index * 0.6));
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 12 + (value * 8),
              width: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    // ignore: deprecated_member_use
                    Colors.white.withOpacity(0.9),
                    Colors.blueAccent.shade100,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            );
          }),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(seconds: 3),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _gradients[_gradientIndex],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // --- Center logo + app title + loader ---
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.white.withOpacity(0.4),
                                blurRadius: 25,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/logo.png",
                            height: 140,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        "FitBuddy Health",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.4,
                          shadows: [
                            Shadow(
                              color: Colors.black38,
                              blurRadius: 8,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _buildWaveLoader(),
                  ],
                ),
              ),

              // --- Footer ---
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: const Text(
                    "Created by Tia Fitrianingsih",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white70,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
