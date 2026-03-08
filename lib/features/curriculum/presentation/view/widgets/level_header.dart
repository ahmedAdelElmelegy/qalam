import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelHeader extends StatelessWidget {
  final CurriculumLevel activeLevel;
  const LevelHeader({super.key, required this.activeLevel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 20.h),
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
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            getLevelTitle(activeLevel, context),
            style: AppTextStyles.h1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 32.sp,
              letterSpacing: -1.5,
            ),
          ).animate().fadeIn().slideY(begin: 0.2, end: 0),
          Text(
            getLevelDescription(activeLevel, context),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ).animate().fadeIn(delay: 150.ms),
          SizedBox(height: 12.h),
          Container(
                height: 3.h,
                width: 60.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFD4AF37), Color(0xFFFFE066)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
              .animate()
              .fadeIn(delay: 250.ms)
              .scaleX(begin: 0, alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}
