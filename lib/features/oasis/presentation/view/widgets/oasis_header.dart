import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';

class OasisHeader extends StatelessWidget {
  const OasisHeader({super.key});

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
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'oasis_title'.tr(),
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 34.sp,
                        letterSpacing: -2,
                        height: 1.0,
                      ),
                    ).animate().fadeIn().slideY(
                          begin: 0.3,
                          end: 0,
                          curve: Curves.easeOutQuart,
                        ),
                    SizedBox(height: 6.h),
                    Text(
                      'oasis_subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.45),
                        letterSpacing: 0.2,
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF06B6D4).withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.waves_rounded,
                  color: Colors.white,
                  size: 26.w,
                ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.12, 1.12),
                      duration: 2.seconds,
                    ),
              ).animate().fadeIn(delay: 200.ms).scale(
                    begin: const Offset(0.7, 0.7),
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
          SizedBox(height: 14.h),
          Container(
            height: 3.h,
            width: 50.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF06B6D4), Color(0xFF67E8F9)],
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
