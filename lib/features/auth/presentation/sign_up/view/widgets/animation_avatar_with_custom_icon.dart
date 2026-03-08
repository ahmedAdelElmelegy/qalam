import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimationAvatarWithCustomIcon extends StatefulWidget {
  const AnimationAvatarWithCustomIcon({super.key});

  @override
  State<AnimationAvatarWithCustomIcon> createState() =>
      _AnimationAvatarWithCustomIconState();
}

class _AnimationAvatarWithCustomIconState
    extends State<AnimationAvatarWithCustomIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
          alignment: Alignment.center,
          children: [
            // Outer glow ring
            AnimatedBuilder(
              animation: _shimmerController,
              builder: (context, child) {
                return Container(
                  width: 140.w,
                  height: 140.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: SweepGradient(
                      colors: [
                        AppColors.accentGold.withValues(alpha: 0.0),
                        AppColors.accentGold.withValues(alpha: 0.5),
                        AppColors.accentGold.withValues(alpha: 0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                      transform: GradientRotation(
                        _shimmerController.value * 2 * 3.14159,
                      ),
                    ),
                  ),
                );
              },
            ),
            // Icon Image
            Container(
              width: 120.w,
              height: 120.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/signup_icon.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 600.ms)
        .scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack);
  }
}
