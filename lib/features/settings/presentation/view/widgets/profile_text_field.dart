import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final int maxLines;
  final String? Function(String?)? validator;
  final int delay;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.icon,
    this.keyboardType,
    this.maxLines = 1,
    this.validator,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: AppTextStyles.overline.copyWith(
              color: AppColors.accentGold.withValues(alpha: 0.8),
              letterSpacing: 1.5,
            ),
          ),
        ),
        GlassContainer(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
          child: TextFormField(
            controller: controller,
            cursorColor: AppColors.accentGold,
            keyboardType: keyboardType,
            validator: validator,
            maxLines: maxLines,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
            ),
            decoration: InputDecoration(
              icon: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.accentGold, size: 20.w),
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorStyle: TextStyle(
                color: Colors.redAccent.withValues(alpha: 0.8),
                fontSize: 12.sp,
              ),
              hintText: label,
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.3),
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: delay.ms).slideX(begin: -0.05, end: 0);
  }
}
