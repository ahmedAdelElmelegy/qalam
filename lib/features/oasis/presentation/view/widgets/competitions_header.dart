import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';

class CompetitionsHeader extends StatelessWidget {
  const CompetitionsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'competitions_title'.tr(),
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32.sp,
                        letterSpacing: -1.5,
                        height: 1.1,
                      ),
                    ).animate().fadeIn().slideY(
                          begin: 0.3,
                          end: 0,
                          curve: Curves.easeOutQuart,
                        ),
                    SizedBox(height: 8.h),
                    Text(
                      'challenges'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFFFE066)],
                  ),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  '5 Arenas',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).scale(
                    begin: const Offset(0.8, 0.8),
                  ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
            height: 3.h,
            width: 50.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFFFE066)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().fadeIn(delay: 300.ms).scaleX(
                begin: 0,
                alignment: Alignment.centerLeft,
              ),
        ],
      ),
    );
  }
}
