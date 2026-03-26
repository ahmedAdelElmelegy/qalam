import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';

class PlaceSentencesList extends StatelessWidget {
  final MuseumPlaceModel place;
  final TtsService ttsService;

  const PlaceSentencesList({
    super.key,
    required this.place,
    required this.ttsService,
  });

  Widget _buildAudioButton(
    VoidCallback onPressed,
    Color bgColor,
    Color iconColor,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(Icons.volume_up_rounded, color: iconColor, size: 24.sp),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final object = place.objects[index];
        final arText = object.localizedNames['ar'] ?? object.arabicName;
        final translatedText =
            object.localizedNames[context.locale.languageCode] ??
            object.englishTranslation;

        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primaryNavy,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                SizedBox(
                  height: 180.h,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: object.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: AppColors.primaryDeep,
                          child: const Center(
                            child: CustomLoadingWidget(size: 30),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.primaryDeep,
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.white24,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 80.h,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withValues(alpha: 0.8),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12.h,
                        left: 12.w,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: AppColors.accentGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              arText,
                              textAlign: TextAlign.right,

                              style: AppTextStyles.arabicTitle.copyWith(
                                fontSize: 22.sp,
                                color: Colors.white,
                                height: 1.3,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          _buildAudioButton(
                            () => ttsService.speak(arText, language: 'ar-SA'),
                            AppColors.accentGold,
                            Colors.black,
                          ),
                        ],
                      ),

                      Divider(
                        color: Colors.white.withValues(alpha: 0.1),
                        height: 30.h,
                      ),

                      Row(
                        children: [
                          _buildAudioButton(
                            () => ttsService.speak(
                              translatedText,
                              language: ttsService.getTtsLanguage(
                                context.locale.languageCode,
                              ),
                            ),
                            Colors.white.withValues(alpha: 0.1),
                            AppColors.accentCyan,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              translatedText,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: Colors.white70,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.1, end: 0);
      }, childCount: place.objects.length),
    );
  }
}
