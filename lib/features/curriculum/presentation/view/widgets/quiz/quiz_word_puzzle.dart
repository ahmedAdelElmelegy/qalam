import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class QuizWordPuzzle extends StatelessWidget {
  final Question question;
  final List<String> shuffledWords;
  final List<String> selectedWords;
  final bool isAnswerChecked;
  final bool isCorrect;
  final Function(String word, bool isSelected) onWordTap;

  const QuizWordPuzzle({
    super.key,
    required this.question,
    required this.shuffledWords,
    required this.selectedWords,
    required this.isAnswerChecked,
    required this.isCorrect,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Selected Words Area
        Container(
          height: 120.h,
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: isAnswerChecked
                  ? (isCorrect ? const Color(0xFF10B981) : Colors.redAccent)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: selectedWords
                .map((word) => _buildWordChip(word, isSelected: true))
                .toList(),
          ),
        ),
        SizedBox(height: 40.h),
        // Word Bank
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          alignment: WrapAlignment.center,
          children: shuffledWords
              .map((word) => _buildWordChip(word, isSelected: false))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildWordChip(String word, {required bool isSelected}) {
    bool isUsed = !isSelected && selectedWords.contains(word);

    return GestureDetector(
      onTap: isAnswerChecked || isUsed
          ? null
          : () => onWordTap(word, isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isUsed
              ? Colors.white.withValues(alpha: 0.02)
              : Colors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFD4AF37)
                : Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Text(
          word,
          style: AppTextStyles.arabicBody.copyWith(
            color: isUsed ? Colors.white24 : Colors.white,
            fontSize: 18.sp,
          ),
        ),
      ),
    ).animate().fadeIn();
  }
}
