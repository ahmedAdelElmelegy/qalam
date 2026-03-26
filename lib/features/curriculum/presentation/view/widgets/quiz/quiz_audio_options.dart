import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class QuizAudioOptions extends StatelessWidget {
  final Question question;
  final String? activeAudioOption;
  final String? selectedAnswer;
  final Function(String) onAudioOptionTap;

  const QuizAudioOptions({
    super.key,
    required this.question,
    required this.activeAudioOption,
    required this.selectedAnswer,
    required this.onAudioOptionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          spacing: 16.w,
          runSpacing: 16.h,
          alignment: WrapAlignment.center,
          children: question.options.map((opt) {
            final isActive = activeAudioOption == opt;
            final isSelected = selectedAnswer == opt;

            return GestureDetector(
              onTap: () => onAudioOptionTap(opt),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 150.w,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFFD4AF37).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(25.r),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFFD4AF37)
                        : Colors.white.withValues(alpha: 0.1),
                    width: 2,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xFFD4AF37).withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ]
                      : [],
                ),
                child: Column(
                  children: [
                    Icon(
                      isActive
                          ? Icons.volume_up_rounded
                          : Icons.volume_down_rounded,
                      color: isSelected ? const Color(0xFFD4AF37) : Colors.white,
                      size: 32.sp,
                    )
                        .animate(target: isActive ? 1 : 0)
                        .scale(
                          begin: const Offset(1, 1),
                          end: const Offset(1.2, 1.2),
                        )
                        .shake(),
                    SizedBox(height: 12.h),
                    Text(
                      "Option",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
