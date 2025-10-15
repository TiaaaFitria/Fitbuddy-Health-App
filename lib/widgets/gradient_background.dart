import 'package:flutter/material.dart';
import 'package:flutter_buddy/model/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final bool applySafeArea;

  const GradientBackground({
    super.key,
    required this.child,
    this.applySafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Color> gradientColors = isDark
        ? [
            // ignore: deprecated_member_use
            AppTheme.primaryBlue.withOpacity(0.7),
            const Color(0xFF0A192F),
          ]
        : [
            AppTheme.lightBlue,
            AppTheme.primaryBlue,
          ];

    final gradientLayer = IgnorePointer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
        ),
      ),
    );

    final backgroundWithChild = Stack(
      children: [
        gradientLayer,
        child,
      ],
    );

    return applySafeArea
        ? SafeArea(child: backgroundWithChild)
        : backgroundWithChild;
  }
}
