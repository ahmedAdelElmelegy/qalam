import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';

class QuizFooter extends StatelessWidget {
  final int currentIndex;
  final int quizLength;
  final bool isSpeaking;
  final bool isAnswerChecked;
  final bool isCorrect;
  final bool hasSelectedAnswer;
  final VoidCallback onCheckAnswer;
  final VoidCallback onNextQuestion;
  final VoidCallback onSkipAudio;

  const QuizFooter({
    super.key,
    required this.currentIndex,
    required this.quizLength,
    required this.isSpeaking,
    required this.isAnswerChecked,
    required this.isCorrect,
    required this.hasSelectedAnswer,
    required this.onCheckAnswer,
    required this.onNextQuestion,
    required this.onSkipAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: const Color(0xFF121225),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSpeaking && !isAnswerChecked) ...[
            TextButton(
              onPressed: onSkipAudio,
              style: TextButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
              ),
              child: Text(
                'skip_audio'.tr(),
                style: AppTextStyles.h4.copyWith(
                  color: Colors.white70,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 12.h),
          ],
          ElevatedButton(
            onPressed: !hasSelectedAnswer
                ? null
                : (isAnswerChecked ? onNextQuestion : onCheckAnswer),
            style: ElevatedButton.styleFrom(
              backgroundColor: isAnswerChecked
                  ? (isCorrect ? const Color(0xFF10B981) : Colors.redAccent)
                  : const Color(0xFFD4AF37),
              minimumSize: Size(double.infinity, 60.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
            ),
            child: Text(
              currentIndex < quizLength - 1
                  ? (isAnswerChecked ? 'quiz_continue'.tr() : 'quiz_check'.tr())
                  : (isAnswerChecked ? 'quiz_finish'.tr() : 'quiz_check'.tr()),
              style: AppTextStyles.h4.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
