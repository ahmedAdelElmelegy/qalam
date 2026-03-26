import 'dart:ui' as ui;
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/history/data/models/history_period_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HistoryStoryAppBarBackground extends StatelessWidget {
  final HistoryPeriodModel period;
  final String languageCode;

  const HistoryStoryAppBarBackground({
    super.key,
    required this.period,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (period.imageUrl.isNotEmpty)
          CachedNetworkImage(
            imageUrl: period.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.black,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.accentGold,
                  ),
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.black,
              child: const Icon(Icons.error, color: Colors.white54),
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                begin: const Offset(1.0, 1.0),
                end: const Offset(1.1, 1.1),
                duration: 15.seconds,
              ),
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.8),
                  Colors.black,
                ],
                stops: const [0.0, 0.4, 0.8, 1.0],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 40.h,
          left: 24.w,
          right: 24.w,
          child: Column(
            crossAxisAlignment: languageCode == 'ar'
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      period.getYearRange(languageCode),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.accentGold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms).slideX(
                    begin: languageCode == 'ar' ? 0.2 : -0.2,
                  ),
              SizedBox(height: 16.h),
              Text(
                period.getTitle('ar'),
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.accentGold,
                  fontSize: 34.sp,
                  fontFamily: 'NotoKufiArabic',
                  fontWeight: FontWeight.bold,
                  shadows: [
                    const Shadow(color: Colors.black, blurRadius: 20),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
              if (languageCode != 'ar') ...[
                SizedBox(height: 8.h),
                Text(
                  period.getTitle(languageCode),
                  style: AppTextStyles.h2.copyWith(
                    color: Colors.white,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w200,
                    shadows: [
                      const Shadow(color: Colors.black, blurRadius: 20),
                    ],
                  ),
                ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
