import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AnimatedLogo extends StatelessWidget {
  final AnimationController logoController;
  final Animation<double> logoScale;
  final Animation<double> logoOpacity;

  const AnimatedLogo({
    super.key,
    required this.logoController,
    required this.logoScale,
    required this.logoOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: logoScale.value,
          child: Opacity(
            opacity: logoOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Image.asset('assets/images/logo_icon.png', width: 140),
            ),
          ),
        );
      },
    );
  }
}
