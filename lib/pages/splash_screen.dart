import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '/model/user_preferences.dart';
import '/model/user_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.6, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _controller.forward();

    Timer(const Duration(seconds: 3), () async {
      UserModel? savedUser = await UserPreferences.getUser();
      if (savedUser != null) {
        Navigator.pushReplacementNamed(context, '/home', arguments: savedUser);
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildLoadingDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = index * 0.6 + _controller.value * 2 * pi;
            return Transform.translate(
              offset: Offset(0, -5 * sin(value)),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: CircleAvatar(radius: 6, backgroundColor: Colors.white),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3E5FC), Color(0xFF1976D2)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Image.asset("assets/logo.png", height: 150),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "FitBuddy Health",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
              ),
              const SizedBox(height: 10),
              const Text(
                "by Tia Fitrianingsih",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white70),
              ),
              const SizedBox(height: 40),
              _buildLoadingDots(),
            ],
          ),
        ),
      ),
    );
  }
}
