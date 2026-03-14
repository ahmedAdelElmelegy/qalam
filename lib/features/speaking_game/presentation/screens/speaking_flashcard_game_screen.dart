import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/features/speaking_game/data/services/flashcard_local_service.dart';
import 'package:arabic/features/speaking_game/data/models/question_model.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_game_cubit.dart';
import 'package:arabic/features/speaking_game/presentation/manager/speaking_game_state.dart';
import 'package:arabic/features/speaking_game/presentation/widgets/flippable_flashcard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/di/injection.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/speaking_game/data/services/speaking_challenge_prefs_service.dart';

class SpeakingFlashcardGameScreen extends StatelessWidget {
  final int day;

  const SpeakingFlashcardGameScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final String currentLocale = context.locale.languageCode;
    return BlocProvider(
      create: (context) =>
          SpeakingGameCubit(localService: FlashcardLocalService())
            ..startGame(day: day, locale: currentLocale),
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
          actions: [
            BlocBuilder<SpeakingGameCubit, SpeakingGameState>(
              builder: (context, state) {
                int correct = 0;
                int total = 0;
                if (state is SpeakingGameLoaded) {
                  correct = state.correctAnswers;
                  total = state.totalCards;
                }

                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: Center(
                    child: Text(
                      total > 0 ? '$correct / $total' : '',
                      style: AppTextStyles.h4.copyWith(
                        color: AppColors.accentGold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        body: _GameBody(day: day),
      ),
    );
  }
}

class _GameBody extends StatelessWidget {
  final int day;
  const _GameBody({required this.day});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SpeakingGameCubit, SpeakingGameState>(
      listener: (context, state) async {
        if (state is SpeakingGameOver) {
          if (state.isWin) {
            getIt<SpeakingChallengePrefsService>().markDayCompleted(day);
          }
          _showGameOverDialog(context, state.isWin, state.percentage);
        } else if (state is SpeakingGameError) {
          if (!await NetworkChecker.hasConnection()) {
            if (context.mounted) {
              NetworkChecker.showNoNetworkDialog(context);
            }
          } else {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          }
        }
      },
      builder: (context, state) {
        if (state is SpeakingGameLoading || state is SpeakingGameInitial) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CustomLoadingWidget(),
                SizedBox(height: 24.h),
                Text(
                      'generating_challenges'.tr(context: context),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 500.ms)
                    .shimmer(color: AppColors.accentGold, duration: 2000.ms),
              ],
            ),
          );
        }

        if (state is SpeakingGameLoaded ||
            state is SpeakingGameChecking ||
            state is SpeakingGameCorrect ||
            state is SpeakingGameIncorrect) {
          bool isListening = false;
          String recognizedText = '';
          int remainingCards = 0;

          QuestionModel? currentCard;

          if (state is SpeakingGameLoaded) {
            isListening = state.isListening;
            recognizedText = state.recognizedText;
            remainingCards = state.cards.length;
            if (state.cards.isNotEmpty) currentCard = state.cards.first;
          } else if (state is SpeakingGameCorrect) {
            currentCard = state.card;
          } else if (state is SpeakingGameIncorrect) {
            currentCard = state.card;
          }

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                children: [
                  // Progress indicator
                  Text(
                    'cards_remaining'.tr(
                      context: context,
                      args: ['$remainingCards'],
                    ),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentGold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 32.h),

                  // Card Stack
                  Expanded(
                    child: Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: _buildCardStack(state),
                      ),
                    ),
                  ),

                  if (currentCard != null &&
                      currentCard.type != 'speaking') ...[
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
                        final option = currentCard!.options[index];
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
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Center(child: optionContent),
                          ),
                        ).animate().scale(delay: (index * 100).ms);
                      },
                    ),
                  ] else ...[
                    // Recognized Text Feedback
                    SizedBox(height: 24.h),
                    SizedBox(
                      height: 60.h,
                      child: Center(
                        child:
                            Text(
                                  recognizedText.isNotEmpty
                                      ? '"$recognizedText"'
                                      : (isListening
                                            ? 'listening'.tr(context: context)
                                            : 'tap_mic_speak'.tr(
                                                context: context,
                                              )),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: isListening
                                        ? AppColors.accentGold
                                        : Colors.white70,
                                    fontStyle: recognizedText.isNotEmpty
                                        ? FontStyle.italic
                                        : FontStyle.normal,
                                  ),
                                )
                                .animate(
                                  key: ValueKey(
                                    recognizedText + isListening.toString(),
                                  ),
                                )
                                .fadeIn(),
                      ),
                    ),

                    // Mic Button
                    SizedBox(height: 16.h),
                    GestureDetector(
                      onTap: () async {
                        final cubit = context.read<SpeakingGameCubit>();
                        if (isListening) {
                          cubit.stopListening();
                        } else {
                          if (!await NetworkChecker.hasConnection()) {
                            if (context.mounted) {
                              NetworkChecker.showNoNetworkDialog(context);
                            }
                            return;
                          }
                          cubit.startListening();
                        }
                      },
                      child:
                          AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                width: isListening ? 90.w : 76.w,
                                height: isListening ? 90.w : 76.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isListening
                                      ? AppColors.accentGold
                                      : Colors.white.withValues(alpha: 0.1),
                                  border: Border.all(
                                    color: isListening
                                        ? Colors.white
                                        : AppColors.accentGold.withValues(
                                            alpha: 0.5,
                                          ),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    if (isListening)
                                      BoxShadow(
                                        color: AppColors.accentGold.withValues(
                                          alpha: 0.6,
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                  ],
                                ),
                                child: Icon(
                                  isListening
                                      ? Icons.stop_rounded
                                      : Icons.mic_rounded,
                                  color: isListening
                                      ? Colors.black
                                      : AppColors.accentGold,
                                  size: 36.w,
                                ),
                              )
                              .animate(target: isListening ? 1 : 0)
                              .scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.1, 1.1),
                              ),
                    ),
                  ],
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  List<Widget> _buildCardStack(SpeakingGameState state) {
    if (state is SpeakingGameLoaded && state.cards.isNotEmpty) {
      return state.cards.reversed.toList().asMap().entries.map((entry) {
        final index = entry
            .key; // reversed index, so top card is last element in state.cards but first evaluated
        final card = entry.value;
        final revIndex = state.cards.length - 1 - index; // 0 is top

        final isTopCard = revIndex == 0;

        return Positioned(
          top: revIndex * 15.0, // Stack effect
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Transform.scale(
              scale: 1.0 - (revIndex * 0.05), // bg cards are smaller
              child: FlippableFlashcard(
                card: card,
                isFlipped:
                    isTopCard &&
                    state
                        .isListening, // Flip to see translation while listening? Or keep front?
              ).animate().fadeIn(delay: (revIndex * 100).ms).slideY(begin: 0.1),
            ),
          ),
        );
      }).toList();
    } else if (state is SpeakingGameCorrect) {
      // Glow and fly away
      return [
        FlippableFlashcard(card: state.card, isFlipped: true, isCorrect: true)
            .animate()
            .scale(end: const Offset(0.8, 0.8))
            .slideY(end: -1.0)
            .fadeOut(duration: 800.ms),
      ];
    } else if (state is SpeakingGameIncorrect) {
      // Shake
      return [
        FlippableFlashcard(
          card: state.card,
          isFlipped: true,
          isIncorrect: true,
        ),
      ];
    } else if (state is SpeakingGameChecking) {
      return [const Center(child: CircularProgressIndicator())];
    }

    return [];
  }

  void _showGameOverDialog(BuildContext context, bool isWin, int percentage) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A2E),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: Text(
            isWin
                ? 'congrats'.tr(context: context)
                : 'game_over'.tr(context: context),
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              color: isWin ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
          content: Text(
            '${'score'.tr(context: context)}: $percentage%',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
              fontSize: 18.sp,
            ),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 32.w,
                    vertical: 12.h,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back
                },
                child: Text(
                  'continue'.tr(context: context),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
