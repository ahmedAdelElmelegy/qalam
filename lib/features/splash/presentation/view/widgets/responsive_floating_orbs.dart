import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/features/splash/presentation/view/widgets/floating_orb.dart';
import 'package:flutter/material.dart';

class ResponsiveFloatingOrbs extends StatelessWidget {
  const ResponsiveFloatingOrbs({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.08,
          child: FloatingOrb(
            size: 100,
            color: AppColors.accentGold.withValues(alpha: 0.15),
            duration: 4,
          ),
        ),
        Positioned(
          top: size.height * 0.25,
          right: size.width * 0.12,
          child: FloatingOrb(
            size: 150,
            color: AppColors.accentGold.withValues(alpha: 0.1),
            duration: 5,
          ),
        ),
        Positioned(
          bottom: size.height * 0.18,
          left: size.width * 0.15,
          child: FloatingOrb(
            size: 80,
            color: AppColors.accentGold.withValues(alpha: 0.12),
            duration: 6,
          ),
        ),
        Positioned(
          bottom: size.height * 0.35,
          right: size.width * 0.1,
          child: FloatingOrb(
            size: 120,
            color: AppColors.primaryNavy.withValues(alpha: 0.2),
            duration: 7,
          ),
        ),
      ],
    );
  }
}
