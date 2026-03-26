import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';

class PlaceDescription extends StatelessWidget {
  final MuseumPlaceModel place;

  const PlaceDescription({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
        child: Column(
          children: [
            Text(
              place.localizedNames[context.locale.languageCode]
                      ?.toUpperCase() ??
                  '',
              style: AppTextStyles.displayMedium.copyWith(
                fontSize: 24.sp,
                color: AppColors.accentGold,
                letterSpacing: 2.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

            SizedBox(height: 20.h),

            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    place.localizedDescriptions['ar'] ?? place.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      height: 1.8,
                      color: Colors.white.withValues(alpha: 0.95),
                      fontFamily: 'NotoKufiArabic',
                      fontSize: 16.sp,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  Divider(
                    color: Colors.white.withValues(alpha: 0.1),
                    thickness: 1,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    place.localizedDescriptions[context.locale.languageCode] ??
                        '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms),

            SizedBox(height: 30.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: AppColors.accentCyan,
                  size: 20.sp,
                ),
                SizedBox(width: 10.w),
                Text(
                  "interactive_learning".tr(),
                  style: AppTextStyles.h4.copyWith(
                    color: AppColors.accentCyan,
                    fontSize: 16.sp,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
