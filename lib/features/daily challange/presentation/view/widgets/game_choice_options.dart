import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_cubit.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameChoiceOptions extends StatelessWidget {
  final QuestionModel currentCard;
  final SpeakingGameState state;

  const GameChoiceOptions({
    super.key,
    required this.currentCard,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 24.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentCard.options.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            crossAxisSpacing: 16.w,
            mainAxisSpacing: 16.h,
          ),
          itemBuilder: (context, index) {
            final option = currentCard.options[index];
            final isChecking = state is SpeakingGameChecking;

            Widget optionContent;
            if (currentCard.type == 'audioOptions') {
              optionContent = Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.accentGold,
                      size: 28.w,
                    ),
                    onPressed: () => TtsService().speak(
                      option,
                      language: 'ar-SA',
                    ),
                  ),
                  Container(
                    width: 1.w,
                    height: 24.h,
                    color: Colors.white24,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Text(
                      '${index + 1}',
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              );
            } else {
              optionContent = Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }

            return InkWell(
              onTap: isChecking
                  ? null
                  : () {
                      context
                          .read<SpeakingGameCubit>()
                          .evaluateMultiChoiceAnswer(option);
                    },
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A2E),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                  ),
                ),
                child: Center(child: optionContent),
              ),
            ).animate().scale(delay: (index * 100).ms);
          },
        ),
      ],
    );
  }
}
