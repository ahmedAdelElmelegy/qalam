import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';

class ProfileHeader extends StatelessWidget {
  final bool isLoading;

  const ProfileHeader({
    super.key,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.w,
        vertical: 16.h,
      ),
      child: Row(
        children: [
          BackButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                AppColors.accentGold.withValues(alpha: 0.1),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              padding: WidgetStatePropertyAll(
                EdgeInsets.all(12.w),
              ),
            ),
            color: AppColors.accentGold,
            onPressed: () => context.pop(),
          ).animate().fadeIn().slideX(begin: -0.2, end: 0),
          SizedBox(width: 16.w),
          Text(
            'edit_profile'.tr(),
            style: AppTextStyles.h2.copyWith(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.2, end: 0),
          const Spacer(),
          if (isLoading)
            SizedBox(
              width: 20.w,
              height: 20.w,
              child: const CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.accentGold,
              ),
            ),
        ],
      ),
    );
  }
}
