import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/video_thumbnail_card.dart';
import 'package:arabic/features/traditions/data/models/tradition_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TraditionStoryVideoSection extends StatelessWidget {
  final TraditionModel tradition;
  final String languageCode;

  const TraditionStoryVideoSection({
    super.key,
    required this.tradition,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (tradition.videoIdea.isEmpty) return const SizedBox.shrink();

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: tradition.videoIdea.startsWith('http')
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Featured Video',
                    style: AppTextStyles.h4.copyWith(
                      color: AppColors.accentGold,
                      fontSize: 18.sp,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  VideoThumbnailCard(
                    videoUrl: tradition.videoIdea,
                    title: tradition.getTitle(languageCode),
                  ),
                ],
              )
            : Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: AppColors.accentGold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.video_library_rounded,
                          color: AppColors.accentGold,
                        ),
                        SizedBox(width: 10.w),
                        Text(
                          'Video Concept',
                          style: AppTextStyles.h4.copyWith(
                            color: AppColors.accentGold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      tradition.videoIdea,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
