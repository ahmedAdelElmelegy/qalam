import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingNavigationButton extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final VoidCallback onPressed;

  const OnboardingNavigationButton({
    super.key,
    required this.currentPage,
    required this.pageCount,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: PremiumButton(
            key: ValueKey(currentPage),
            text: (currentPage == pageCount - 1 ? 'Get Started' : 'Next'),
            onPressed: onPressed,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.5, end: 0);
  }
}
