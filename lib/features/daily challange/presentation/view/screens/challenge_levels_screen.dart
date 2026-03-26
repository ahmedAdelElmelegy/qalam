import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/challenge_level_card.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/daily_challenge_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/di/injection.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_challenge_levels_cubit.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_challenge_levels_state.dart';

class ChallengeLevelsScreen extends StatelessWidget {
  const ChallengeLevelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: getIt<SpeakingChallengeLevelsCubit>()..loadLevels(),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A1A),
        appBar: const DailyChallengeAppBar(),
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

                        return ChallengeLevelCard(
                          day: day,
                          isUnlocked: isUnlocked,
                          isCompleted: isCompleted,
                          index: index,
                          color: color,
                          difficulty: difficulty,
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
}
