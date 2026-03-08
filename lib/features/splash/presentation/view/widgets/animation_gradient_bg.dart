import 'dart:math';

import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AnimatedGradientBackground extends StatelessWidget {
  final AnimationController controller;

  const AnimatedGradientBackground({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primaryDark,
                AppColors.primaryNavy,
                Color.lerp(
                  AppColors.primaryNavy,
                  AppColors.primaryDeep,
                  (sin(controller.value * 2 * pi) + 1) / 2,
                )!,
              ],
            ),
          ),
        );
      },
    );
  }
}
