import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/daily%20challange/presentation/view/screens/speaking_flashcard_game_screen.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_challenge_levels_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChallengeLevelCard extends StatelessWidget {
  final int day;
  final bool isUnlocked;
  final bool isCompleted;
  final int index;
  final Color color;
  final String difficulty;

  const ChallengeLevelCard({
    super.key,
    required this.day,
    required this.isUnlocked,
    required this.isCompleted,
    required this.index,
    required this.color,
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Opacity(
        opacity: isUnlocked ? 1.0 : 0.6,
        child: InkWell(
          onTap: isUnlocked
              ? () async {
                  await context.push(
                    SpeakingFlashcardGameScreen(day: day),
                  );
                  // Refresh when returning
                  if (context.mounted) {
                    context.read<SpeakingChallengeLevelsCubit>().loadLevels();
                  }
                }
              : null,
          borderRadius: BorderRadius.circular(16.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.w,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$day',
                      style: AppTextStyles.h2.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'day_n'.tr(context: context, args: ['$day']),
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        isUnlocked
                            ? 'difficulty'.tr(
                                context: context,
                                args: [difficulty.tr(context: context)],
                              )
                            : 'locked'.tr(context: context),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white54,
                          fontSize: 12.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                isCompleted
                    ? Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 28.w,
                      )
                    : isUnlocked
                        ? Icon(
                            Icons.mic_rounded,
                            color: color.withValues(alpha: 0.8),
                            size: 24.w,
                          )
                        : Icon(
                            Icons.lock_rounded,
                            color: Colors.white54,
                            size: 24.w,
                          ),
              ],
            ),
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (index * 50).ms)
          .slideX(begin: 0.1),
    );
  }
}
