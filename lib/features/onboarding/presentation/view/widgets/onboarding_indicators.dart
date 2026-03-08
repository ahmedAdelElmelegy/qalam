import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingIndicators extends StatelessWidget {
  final int currentPage;
  final int pageCount;

  const OnboardingIndicators({
    super.key,
    required this.currentPage,
    required this.pageCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          width: isActive ? 34.w : 10.w,
          height: 8.h,
          decoration: BoxDecoration(
            gradient: isActive ? AppColors.goldGradient : null,
            color: isActive ? null : Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.4),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
        ).animate(delay: (index * 50).ms).fadeIn().scale();
      }),
    ).animate().fadeIn(delay: 800.ms);
  }
}
