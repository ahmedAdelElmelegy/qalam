import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: AppColors.accentGold,
            fontSize: 13.sp,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: 2,
          color: AppColors.accentGold.withValues(alpha: 0.3),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }
}
