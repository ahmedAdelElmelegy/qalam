import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/speaking_game/presentation/screens/speaking_flashcard_game_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/di/injection.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_challenge_levels_cubit.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_challenge_levels_state.dart';

class SpeakingChallengeLevelsScreen extends StatelessWidget {
  const SpeakingChallengeLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SpeakingChallengeLevelsCubit>()..loadLevels(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A1A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'daily_challenge'.tr(context: context),
            style: AppTextStyles.displayMedium.copyWith(
              color: Colors.white,
              fontSize: 20.sp,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child:
              BlocBuilder<
                SpeakingChallengeLevelsCubit,
                SpeakingChallengeLevelsState
              >(
                builder: (context, state) {
                  if (state is SpeakingChallengeLevelsLoaded) {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 16.h,
                      ),
                      itemCount: 50,
                      itemBuilder: (context, index) {
                        final day = index + 1;
                        final isUnlocked = state.unlockedDays[index];
                        final isCompleted = state.completedDays[index];

                        final difficulty = _getDifficulty(day);
                        final color = isUnlocked
                            ? _getColor(difficulty)
                            : Colors.grey;

                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child:
                              Opacity(
                                    opacity: isUnlocked ? 1.0 : 0.6,
                                    child: InkWell(
                                      onTap: isUnlocked
                                          ? () async {
                                              await context.push(
                                                SpeakingFlashcardGameScreen(
                                                  day: day,
                                                ),
                                              );
                                              // Refresh when returning
                                              if (context.mounted) {
                                                context
                                                    .read<
                                                      SpeakingChallengeLevelsCubit
                                                    >()
                                                    .loadLevels();
                                              }
                                            }
                                          : null,
                                      borderRadius: BorderRadius.circular(16.r),
                                      child: Container(
                                        padding: EdgeInsets.all(20.w),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1A1A2E),
                                          borderRadius: BorderRadius.circular(
                                            16.r,
                                          ),
                                          border: Border.all(
                                            color: color.withValues(alpha: 0.3),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withValues(
                                                alpha: 0.1,
                                              ),
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
                                                color: color.withValues(
                                                  alpha: 0.2,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  '$day',
                                                  style: AppTextStyles.h2
                                                      .copyWith(
                                                        color: color,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 16.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'day_n'.tr(
                                                      context: context,
                                                      args: ['$day'],
                                                    ),
                                                    style: AppTextStyles.h4
                                                        .copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                  SizedBox(height: 4.h),
                                                  Text(
                                                    isUnlocked
                                                        ? 'difficulty'.tr(
                                                            context: context,
                                                            args: [
                                                              difficulty.tr(
                                                                context:
                                                                    context,
                                                              ),
                                                            ],
                                                          )
                                                        : 'locked'.tr(
                                                            context: context,
                                                          ),
                                                    style: AppTextStyles
                                                        .bodySmall
                                                        .copyWith(
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
                                                    color: color.withValues(
                                                      alpha: 0.8,
                                                    ),
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
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
        ),
      ),
    );
  }

  String _getDifficulty(int day) {
    if (day <= 15) return 'easy';
    if (day <= 35) return 'medium';
    return 'hard';
  }

  Color _getColor(String difficulty) {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF10B981); // Green
      case 'medium':
        return const Color(0xFFF59E0B); // Orange
      case 'hard':
        return const Color(0xFFEF4444); // Red
      default:
        return AppColors.accentGold;
    }
  }

  // void _showOptionsBottomSheet(BuildContext context, int day, Color color) {}
}
