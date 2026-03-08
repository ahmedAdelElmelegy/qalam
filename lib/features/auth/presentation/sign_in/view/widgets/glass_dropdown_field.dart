import 'dart:ui';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Glass Dropdown Field
/// Beautiful glassmorphic dropdown matching the app's design system
class GlassDropdownField<T> extends StatelessWidget {
  final String? hintText;
  final IconData? prefixIcon;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? Function(T?)? validator;

  const GlassDropdownField({
    super.key,
    this.hintText,
    this.prefixIcon,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.accentGold.withValues(alpha: 0.05),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: DropdownButtonFormField<T>(
              initialValue: value,
              items: items,
              onChanged: onChanged,
              validator: validator,
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: prefixIcon != null
                    ? Icon(
                        prefixIcon,
                        color: AppColors.accentGold.withValues(alpha: 0.7),
                        size: 20.sp,
                      )
                    : null,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  borderSide: BorderSide(color: AppColors.error, width: 2),
                ),
                errorStyle: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: prefixIcon != null ? 12.w : 20.w,
                  vertical: 16.h,
                ),
              ),
              dropdownColor: AppColors.primaryNavy.withValues(alpha: 0.95),
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              icon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accentGold,
                size: 24.sp,
              ),
              isExpanded: true,
            ),
          ),
        ),
      ),
    );
  }
}
