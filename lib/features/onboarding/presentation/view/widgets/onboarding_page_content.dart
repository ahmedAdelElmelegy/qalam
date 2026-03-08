import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingPageContent extends StatelessWidget {
  final int index;
  final double pageOffset;
  final double opacity;
  final BoxConstraints constraints;
  final Map<String, dynamic> pageData;
  final bool isLandscape;

  const OnboardingPageContent({
    super.key,
    required this.index,
    required this.pageOffset,
    required this.opacity,
    required this.constraints,
    required this.pageData,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    final scale = 0.85 + (opacity * 0.15);

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w),
          child: isLandscape
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(child: _buildImage()),
                    SizedBox(width: 40.w),
                    Expanded(
                      child: SingleChildScrollView(child: _buildTextContent()),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImage(),
                    SizedBox(height: 48.h),
                    _buildTextContent(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    double imageSize = 220.w;
    
    // Scale dynamically based on available height and width
    if (constraints.maxWidth > 600) {
       // Tablet size
       imageSize = 300.w;
    }
    
    // Safety check for extreme wide but short screens (Landscape phones)
    final double maxSafeHeight = constraints.maxHeight * (isLandscape ? 0.6 : 0.45);
    if (imageSize > maxSafeHeight) {
      imageSize = maxSafeHeight;
    }

    return Transform.translate(
      offset: Offset(pageOffset * 50, 0),
      child: Center(
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: AppColors.accentGold.withValues(alpha: 0.3 * opacity),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Image.asset(pageData['image'], fit: BoxFit.contain),
          ),
        )
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .moveY(begin: -10, end: 10, duration: 2000.ms, curve: Curves.easeInOut)
            .animate(delay: (index * 100).ms)
            .fadeIn(duration: 600.ms)
            .scale(begin: const Offset(0.8, 0.8), curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildTextContent() {
    final subtitle = pageData['subtitle'] as String?;

    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
      borderRadius: BorderRadius.circular(28),
      blur: 18,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Page number pill
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accentGold.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              '${index + 1} / 3',
              style: AppTextStyles.overline.copyWith(
                color: AppColors.accentGold,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
          )
              .animate(delay: (index * 100 + 200).ms)
              .fadeIn(duration: 400.ms)
              .slideY(begin: 0.3, end: 0),

          SizedBox(height: 16.h),

          // Title
          Text(
            (pageData['title'] as String).tr(),
            style: AppTextStyles.displayLarge.copyWith(
              letterSpacing: 0.5,
              height: 1.15,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          )
              .animate(delay: (index * 100 + 300).ms)
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic),

          // Subtitle
          if (subtitle != null) ...[
            SizedBox(height: 12.h),
            // Thin gold divider line
            Container(
              width: 40.w,
              height: 2.h,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accentGold.withValues(alpha: 0),
                    AppColors.accentGold,
                    AppColors.accentGold.withValues(alpha: 0),
                  ],
                ),
                borderRadius: BorderRadius.circular(1),
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              subtitle.tr(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.5,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            )
                .animate(delay: (index * 100 + 500).ms)
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.15, end: 0, curve: Curves.easeOutCubic),
          ],
        ],
      ),
    );
  }
}
