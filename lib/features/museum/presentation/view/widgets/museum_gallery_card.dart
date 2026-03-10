import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import '../../../data/models/museum_place_model.dart';

class MuseumGalleryCard extends StatelessWidget {
  final MuseumPlaceModel place;
  final VoidCallback onTap;

  const MuseumGalleryCard({
    super.key,
    required this.place,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 310.w,
          height: 500.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          child: RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background Image with Hero
                  Hero(
                    tag: 'place_${place.id}',
                    child: place.imageUrl.startsWith('http')
                        ? CachedNetworkImage(
                            imageUrl: place.imageUrl,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Container(
                              color: AppColors.primaryNavy,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.white24,
                                      size: 40.w,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'image_unavailable'.tr(),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Container(
                              color: AppColors.primaryNavy,
                              child: const CustomLoadingWidget(size: 40),
                            ),
                          )
                        : Image.asset(
                            place.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                              color: AppColors.primaryNavy,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_not_supported_outlined,
                                      color: Colors.white24,
                                      size: 40.w,
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'image_unavailable'.tr(),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: Colors.white24,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                  ),

                  // Sophisticated Gradient Overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.transparent,
                            AppColors.primaryNavy.withValues(alpha: 0.5),
                            AppColors.primaryNavy.withValues(alpha: 0.95),
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),

                  // Content
                  Padding(
                    padding: EdgeInsets.all(28.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Badge
                        Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.2,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.accentGold.withValues(
                                    alpha: 0.5,
                                  ),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: AppColors.accentGold,
                                    size: 14.w,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    'interactive_tour'.tr(),
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.accentGold,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 400.ms)
                            .slideX(begin: -0.2, end: 0),

                        SizedBox(height: 16.h),

                        // Arabic Title (Distinctive)
                        if (place.localizedNames['ar'] != null)
                          Text(
                                place.localizedNames['ar']!,
                                style: AppTextStyles.arabicTitle.copyWith(
                                  fontSize: 28.sp,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                // textDirection:  TextDirection.RTL,
                              )
                              .animate()
                              .fadeIn(delay: 450.ms)
                              .slideX(begin: 0.2, end: 0),

                        SizedBox(height: 4.h),

                        // English Title
                        Text(
                              place.localizedNames[context.locale.languageCode] ??
                                  '',
                              style: AppTextStyles.displayLarge.copyWith(
                                fontSize: 24.sp, // Slightly smaller to balance
                                letterSpacing: -0.5,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 500.ms)
                            .slideY(begin: 0.2, end: 0),

                        SizedBox(height: 8.h),

                        // Description
                        Text(
                              place.localizedDescriptions[context
                                      .locale
                                      .languageCode] ??
                                  '',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            )
                            .animate()
                            .fadeIn(delay: 600.ms)
                            .slideY(begin: 0.2, end: 0),

                        SizedBox(height: 24.h),

                        // Glass Action Button
                        Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(
                                  alpha: 0.15,
                                ), // Increased opacity slightly
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  width: 1,
                                ),
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.white.withValues(alpha: 0.15),
                                    Colors.white.withValues(alpha: 0.05),
                                  ],
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'explore_now'.tr(),
                                    style: AppTextStyles.buttonMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 18.w,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: 700.ms)
                            .scale(begin: const Offset(0.8, 0.8)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
