import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:easy_localization/easy_localization.dart';

class QuizQuestionText extends StatelessWidget {
  final Question question;
  final bool isPlayingQuestion;
  final VoidCallback onTapAudio;

  const QuizQuestionText({
    super.key,
    required this.question,
    required this.isPlayingQuestion,
    required this.onTapAudio,
  });

  @override
  Widget build(BuildContext context) {
    final String text = (question.type == QuestionType.fillInTheBlank)
        ? "Identify the missing letter"
        : (question.textTranslations[context.locale.languageCode] ??
              question.text);

    final QuestionType type = question.type;
    final bool isListening = type == QuestionType.listening;

    Widget questionContent;
    if (isListening) {
      questionContent = const SizedBox.shrink();
    } else {
      final RegExp arabicRegex = RegExp(
        r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]+',
      );
      if (arabicRegex.hasMatch(text) && RegExp(r'[a-zA-Z]').hasMatch(text)) {
        final arabicMatch = arabicRegex.stringMatch(text) ?? '';
        final englishPart = text.replaceAll(arabicRegex, '').trim();
        final arabicPart = arabicMatch.trim();

        if (englishPart.isNotEmpty && arabicPart.isNotEmpty) {
          questionContent = Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12.w,
            children: [
              Text(
                englishPart,
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                arabicPart,
                style: AppTextStyles.arabicBody.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: arabicPart.length <= 3 ? 60.sp : 32.sp,
                ),
              ),
            ],
          );
        } else {
          questionContent = _buildDefaultCenteredText(text);
        }
      } else {
        questionContent = _buildDefaultCenteredText(text);
      }
    }

    return Column(
      children: [
        questionContent,
        SizedBox(height: isListening ? 40.h : 12.h),
        if (type != QuestionType.audioOptions &&
            type != QuestionType.speaking &&
            type != QuestionType.multipleChoice)
          GestureDetector(
                onTap: onTapAudio,
                child: Container(
                  width: isListening ? 80.w : null,
                  height: isListening ? 80.w : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: isListening ? 0 : 24.w,
                    vertical: isListening ? 0 : 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: isPlayingQuestion
                        ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                        : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                    shape: isListening ? BoxShape.circle : BoxShape.rectangle,
                    borderRadius: isListening
                        ? null
                        : BorderRadius.circular(30.r),
                    border: Border.all(
                      color: isPlayingQuestion
                          ? const Color(0xFFD4AF37)
                          : const Color(0xFFD4AF37).withValues(alpha: 0.3),
                      width: isPlayingQuestion ? 2 : 1,
                    ),
                    boxShadow: isPlayingQuestion
                        ? [
                            BoxShadow(
                              color: const Color(
                                0xFFD4AF37,
                              ).withValues(alpha: 0.3),
                              blurRadius: 20,
                              spreadRadius: 5,
                            ),
                          ]
                        : [],
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPlayingQuestion
                              ? Icons.graphic_eq_rounded
                              : Icons.play_arrow_rounded,
                          color: const Color(0xFFD4AF37),
                          size: isListening ? 36.w : 28.w,
                        ),
                        if (!isListening && type == QuestionType.listening) ...[
                          SizedBox(width: 8.w),
                          Text(
                            'LISTEN',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFFD4AF37),
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              )
              .animate(target: isPlayingQuestion ? 1 : 0)
              .shimmer(
                duration: 1000.ms,
                color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
              ),
        if (isListening) ...[
          SizedBox(height: 20.h),
          Text(
            'Listen carefully and select the correct option',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white38),
          ),
        ],
      ],
    ).animate().fadeIn().slideY(begin: 0.1, end: 0);
  }

  Widget _buildDefaultCenteredText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: AppTextStyles.arabicBody.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: text.trim().length <= 3 ? 60.sp : 26.sp,
      ),
    );
  }
}
