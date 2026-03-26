import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'quiz_option.dart';

class QuizFillInTheBlank extends StatelessWidget {
  final Question question;
  final String? selectedAnswer;
  final bool isAnswerChecked;
  final bool isCorrect;
  final Function(String option) onOptionTap;

  const QuizFillInTheBlank({
    super.key,
    required this.question,
    required this.selectedAnswer,
    required this.isAnswerChecked,
    required this.isCorrect,
    required this.onOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    final parts = question.text.split('___');
    final prefix = parts.isNotEmpty ? parts[0] : '';
    final suffix = parts.length > 1 ? parts[1] : '';

    final String blankContent;
    if (isAnswerChecked && !isCorrect) {
      blankContent = question.correctAnswer;
    } else {
      blankContent = selectedAnswer ?? '';
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: AppTextStyles.arabicBody.copyWith(
                color: Colors.white,
                fontSize: 36.sp,
                height: 1.8,
              ),
              children: [
                TextSpan(text: prefix),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: EdgeInsets.symmetric(horizontal: 6.w),
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 2.h,
                    ),
                    constraints: BoxConstraints(minWidth: 44.w),
                    decoration: BoxDecoration(
                      color: isAnswerChecked
                          ? (isCorrect
                              ? const Color(0xFF10B981).withValues(alpha: 0.15)
                              : Colors.redAccent.withValues(alpha: 0.15))
                          : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border(
                        bottom: BorderSide(
                          color: isAnswerChecked
                              ? (isCorrect
                                  ? const Color(0xFF10B981)
                                  : Colors.redAccent)
                              : const Color(0xFFD4AF37),
                          width: 2.5,
                        ),
                      ),
                    ),
                    child: Text(
                      blankContent,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isAnswerChecked
                            ? (isCorrect
                                ? const Color(0xFF10B981)
                                : Colors.redAccent)
                            : const Color(0xFFD4AF37),
                        fontSize: 34.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppTextStyles.arabicBody.fontFamily,
                      ),
                    ),
                  ),
                ),
                TextSpan(text: suffix),
              ],
            ),
          ),
        ),
        SizedBox(height: 40.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          alignment: WrapAlignment.center,
          children: question.options
              .map((opt) => QuizOption(
                    option: opt,
                    correct: question.correctAnswer,
                    isSelected: selectedAnswer == opt,
                    isAnswerChecked: isAnswerChecked,
                    onTap: () => onOptionTap(opt),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
