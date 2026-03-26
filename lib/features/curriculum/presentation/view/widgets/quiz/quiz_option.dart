import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';

class QuizOption extends StatelessWidget {
  final String option;
  final String correct;
  final bool isSelected;
  final bool isAnswerChecked;
  final VoidCallback onTap;

  const QuizOption({
    super.key,
    required this.option,
    required this.correct,
    required this.isSelected,
    required this.isAnswerChecked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isCorrectOption = option == correct;

    Color borderColor = Colors.white.withValues(alpha: 0.12);
    Color bgColor = Colors.white.withValues(alpha: 0.05);

    if (isAnswerChecked) {
      if (isCorrectOption) {
        borderColor = const Color(0xFF10B981);
        bgColor = const Color(0xFF10B981).withValues(alpha: 0.1);
      } else if (isSelected && !isCorrectOption) {
        borderColor = Colors.redAccent;
        bgColor = Colors.redAccent.withValues(alpha: 0.1);
      }
    } else if (isSelected) {
      borderColor = const Color(0xFFD4AF37);
      bgColor = const Color(0xFFD4AF37).withValues(alpha: 0.1);
    }

    return GestureDetector(
      onTap: isAnswerChecked ? null : onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 16.h),
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: borderColor, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isAnswerChecked && isCorrectOption) ...[
              const Icon(Icons.check_circle_rounded, color: Color(0xFF10B981)),
              SizedBox(width: 12.w),
            ] else if (isAnswerChecked && isSelected && !isCorrectOption) ...[
              const Icon(Icons.cancel_rounded, color: Colors.redAccent),
              SizedBox(width: 12.w),
            ] else ...[
              SizedBox(width: 36.w),
            ],
            Expanded(
              child: Text(
                option,
                textAlign: TextAlign.right,
                style: AppTextStyles.arabicBody.copyWith(
                  color: Colors.white,
                  fontSize: 22.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }
}
