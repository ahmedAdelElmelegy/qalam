import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/video_thumbnail_card.dart';
import 'package:arabic/features/food/data/models/food_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodStoryVideoSection extends StatelessWidget {
  final FoodModel food;
  final String languageCode;

  const FoodStoryVideoSection({
    super.key,
    required this.food,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (food.videoIdea.isEmpty) return const SizedBox.shrink();

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: food.videoIdea.startsWith('http')
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
                    videoUrl: food.videoIdea,
                    title: food.getTitle(languageCode),
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
                      food.videoIdea,
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
