import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_video_player.dart';
import 'package:arabic/features/clothing/data/models/clothing_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClothingStoryVideoSection extends StatelessWidget {
  final ClothingModel clothing;
  final String languageCode;

  const ClothingStoryVideoSection({
    super.key,
    required this.clothing,
    required this.languageCode,
  });

  @override
  Widget build(BuildContext context) {
    if (clothing.videoIdea.isEmpty) return const SizedBox.shrink();

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: clothing.videoIdea.startsWith('http')
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
                  CustomVideoPlayer(
                    videoUrl: clothing.videoIdea,
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
                      clothing.videoIdea,
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
