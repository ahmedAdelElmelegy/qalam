import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/daily%20challange/data/services/flashcard_local_service.dart';
import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_cubit.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_state.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/flippable_flashcard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/di/injection.dart';
import 'package:arabic/features/daily%20challange/data/services/speaking_challenge_prefs_service.dart';

import 'package:arabic/features/daily%20challange/presentation/view/widgets/daily_challenge_app_bar.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/game_loading_view.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/game_mic_section.dart';
import 'package:arabic/features/daily%20challange/presentation/view/widgets/game_choice_options.dart';

class SpeakingFlashcardGameScreen extends StatelessWidget {
  final int day;

  const SpeakingFlashcardGameScreen({super.key, required this.day});

  @override
  Widget build(BuildContext context) {
    final String currentLocale = context.locale.languageCode;
    return BlocProvider(
      create: (context) => SpeakingGameCubit(localService: FlashcardLocalService())
            ..startGame(day: day, locale: currentLocale),
      child: Scaffold(
        backgroundColor: const Color(0xFF0A0A1A),
        appBar: DailyChallengeAppBar(
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          }
        }
      },
      builder: (context, state) {
        if (state is SpeakingGameLoading || state is SpeakingGameInitial) {
          return const GameLoadingView();
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
                  Text(
                    'cards_remaining'.tr(context: context, args: ['$remainingCards']),
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

                  if (currentCard != null && currentCard.type != 'speaking')
                    GameChoiceOptions(currentCard: currentCard, state: state)
                  else
                    GameMicSection(isListening: isListening, recognizedText: recognizedText),
                  
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
        final index = entry.key;
        final card = entry.value;
        final revIndex = state.cards.length - 1 - index;
        final isTopCard = revIndex == 0;

        return Positioned(
          top: revIndex * 15.0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Transform.scale(
              scale: 1.0 - (revIndex * 0.05),
              child: FlippableFlashcard(
                card: card,
                isFlipped: isTopCard && state.isListening,
              ).animate().fadeIn(delay: (revIndex * 100).ms).slideY(begin: 0.1),
            ),
          ),
        );
      }).toList();
    } else if (state is SpeakingGameCorrect) {
      return [
        FlippableFlashcard(card: state.card, isFlipped: true, isCorrect: true)
            .animate()
            .scale(end: const Offset(0.8, 0.8))
            .slideY(end: -1.0)
            .fadeOut(duration: 800.ms),
      ];
    } else if (state is SpeakingGameIncorrect) {
      return [
        FlippableFlashcard(card: state.card, isFlipped: true, isIncorrect: true),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
          title: Text(
            isWin ? 'congrats'.tr(context: context) : 'game_over'.tr(context: context),
            textAlign: TextAlign.center,
            style: AppTextStyles.h2.copyWith(
              color: isWin ? const Color(0xFF10B981) : const Color(0xFFEF4444),
            ),
          ),
          content: Text(
            '${'score'.tr(context: context)}: $percentage%',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70, fontSize: 18.sp),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentGold,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                  padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.pop(context); // go back
                },
                child: Text(
                  'continue'.tr(context: context),
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
