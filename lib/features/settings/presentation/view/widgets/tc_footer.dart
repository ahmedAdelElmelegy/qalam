import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';

class TCFooter extends StatelessWidget {
  const TCFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'last_updated'.tr(
              args: [
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
              ],
            ),
            style: AppTextStyles.overline.copyWith(
              color: Colors.white30,
              fontSize: 11.sp,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Qalam Arabic © ${DateTime.now().year}',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white24,
              fontSize: 12.sp,
            ),
          )
        ],
      ),
    ).animate().fadeIn(delay: 900.ms);
  }
}
