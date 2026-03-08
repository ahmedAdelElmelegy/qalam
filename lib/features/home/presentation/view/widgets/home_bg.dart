import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';

class HomeBackground extends StatelessWidget {
  final Widget child;
  const HomeBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryNavy.withValues(alpha: 0.70),
            AppColors.primaryNavy.withValues(alpha: 0.75),
            const Color(0xFF2C3E50).withValues(alpha: 0.80),
          ],
        ),
      ),
      child: child,
    );
  }
}
