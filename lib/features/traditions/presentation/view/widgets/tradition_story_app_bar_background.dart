import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/traditions/data/models/tradition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tradition_image.dart';

class TraditionStoryAppBarBackground extends StatelessWidget {
  final TraditionModel tradition;
  final String languageCode;

  const TraditionStoryAppBarBackground({
    super.key,
    required this.tradition,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        if (tradition.gallery.isNotEmpty)
          TraditionImage(
            imagePath: tradition.gallery.first,
            fit: BoxFit.cover,
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
              Text(
                tradition.getTitle('ar'),
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
                  tradition.getTitle(languageCode),
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
