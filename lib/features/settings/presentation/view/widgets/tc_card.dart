import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';

class TCCard extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String content;
  final int delay;

  const TCCard({
    super.key,
    required this.number,
    required this.icon,
    required this.title,
    required this.content,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GlassContainer(
        padding: EdgeInsets.all(20.w),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.accentGold, size: 24.w),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'section_number'.tr(args: [number]),
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.accentGold.withValues(alpha: 0.8),
                          letterSpacing: 2,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        title,
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.6,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms, duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
    );
  }
}
