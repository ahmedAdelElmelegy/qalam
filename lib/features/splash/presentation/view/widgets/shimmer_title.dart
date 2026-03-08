import 'dart:math';

import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';

class ShimmerTitle extends StatelessWidget {
  final AnimationController textController;
  final AnimationController shimmerController;
  final Animation<double> textOpacity;
  final Animation<double> shimmerPosition;

  const ShimmerTitle({
    super.key,
    required this.textController,
    required this.shimmerController,
    required this.textOpacity,
    required this.shimmerPosition,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([textController, shimmerController]),
      builder: (context, child) {
        return Opacity(
          opacity: textOpacity.value,
          child: ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  AppColors.accentGold,
                  Colors.white,
                  AppColors.accentGold,
                ],
                stops: [
                  max(0.0, shimmerPosition.value - 0.3),
                  shimmerPosition.value,
                  min(1.0, shimmerPosition.value + 0.3),
                ],
              ).createShader(bounds);
            },
            child: Text(
              'app_name_title'.tr(),
              style: AppTextStyles.displayLarge.copyWith(
                fontSize: 56.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
          ),
        );
      },
    );
  }
}
