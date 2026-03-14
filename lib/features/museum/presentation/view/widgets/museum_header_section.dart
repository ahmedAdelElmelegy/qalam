import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MuseumHeaderSection extends StatelessWidget {
  const MuseumHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child:
              Container(
                    width: 140.w,
                    height: 140.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accentGold.withValues(alpha: 0.1),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withValues(alpha: 0.2),
                          blurRadius: 40,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.account_balance_rounded,
                      size: 70.w,
                      color: AppColors.accentGold,
                    ),
                  )
                  .animate(onPlay: (controller) => controller.repeat())
                  .shimmer(
                    duration: 3.seconds,
                    color: Colors.white.withValues(alpha: 0.2),
                  )
                  .moveY(
                    begin: -5,
                    end: 5,
                    duration: 2.seconds,
                    curve: Curves.easeInOut,
                  ),
        ),

        SizedBox(height: 40.h),

        Text(
          'explore_heritage'.tr(),
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.accentGold,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ).animate().fadeIn(delay: 200.ms),

        Text(
              'museum_subtitle'.tr(),
              style: AppTextStyles.displayLarge.copyWith(fontSize: 32.sp),
            )
            .animate()
            .fadeIn(delay: 400.ms)
            .slideY(begin: 0.1, end: 0),
      ],
    );
  }
}
