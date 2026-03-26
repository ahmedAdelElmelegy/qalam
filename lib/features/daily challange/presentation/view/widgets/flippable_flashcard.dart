import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlippableFlashcard extends StatelessWidget {
  final QuestionModel card;
  final bool isFlipped;
  final bool isCorrect;
  final bool isIncorrect;

  const FlippableFlashcard({
    super.key,
    required this.card,
    this.isFlipped = false,
    this.isCorrect = false,
    this.isIncorrect = false,
  });

  @override
  Widget build(BuildContext context) {
    // Determine glow and border colors based on state
    Color borderColor = Colors.white.withValues(alpha: 0.2);
    Color glowColor = Colors.transparent;

    if (isCorrect) {
      borderColor = const Color(0xFF10B981); // Emerald green
      glowColor = const Color(0xFF10B981).withValues(alpha: 0.5);
    } else if (isIncorrect) {
      borderColor = const Color(0xFFEF4444); // Red
      glowColor = const Color(0xFFEF4444).withValues(alpha: 0.5);
    } else if (isFlipped) {
      borderColor = AppColors.accentGold;
      glowColor = AppColors.accentGold.withValues(alpha: 0.3);
    }

    Widget cardContent = AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 340.w,
      height: 380.h,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E), // Dark rich background
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(color: borderColor, width: isFlipped ? 2 : 1),
        boxShadow: [
          BoxShadow(color: glowColor, blurRadius: 20, spreadRadius: 2),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isFlipped && card.type == 'listening') ...[
                GestureDetector(
                  onTap: () {
                    final lang = card.type == 'listening' ? 'ar-SA' : 'en-US';
                    TtsService().speak(card.frontText, language: lang);
                  },
                  child: Container(
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: AppColors.accentGold.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.accentGold.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.accentGold,
                      size: 64.w,
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Text(
                  'tap_to_listen'.tr(context: context),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
              ] else ...[
                Text(
                  isFlipped ? card.backText : card.frontText,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.h1.copyWith(
                    color: isFlipped ? AppColors.accentGold : Colors.white,
                    fontSize: isFlipped ? 38.sp : 32.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: isFlipped ? 0 : 1,
                    fontFamily: (isFlipped || card.type == 'speaking')
                        ? 'Cairo'
                        : null,
                  ),
                ),
                if (isFlipped && card.type == 'speaking') ...[
                  SizedBox(height: 20.h),
                  Text(
                    'pronounce_correctly'.tr(context: context),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white54,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );

    // If we need the 3D flip transform, flutter_animate makes it easy
    Widget animatedCard = cardContent;

    if (isFlipped) {
      animatedCard = cardContent
          .animate(target: isFlipped ? 1 : 0)
          .flip(
            direction: Axis.horizontal,
            duration: 600.ms,
            curve: Curves.easeOutBack,
          );
    }

    if (isCorrect) {
      animatedCard = animatedCard
          .animate()
          .scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 200.ms,
          )
          .shimmer(color: Colors.white, duration: 500.ms);
    }

    if (isIncorrect) {
      animatedCard = animatedCard.animate().shakeX(
        hz: 8,
        amount: 10,
        duration: 500.ms,
      );
    }

    return animatedCard;
  }
}
