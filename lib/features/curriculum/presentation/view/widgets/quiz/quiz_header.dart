import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';

class QuizHeader extends StatelessWidget {
  final double progress;
  final int currentIndex;
  final int totalQuestions;
  final VoidCallback onClose;

  const QuizHeader({
    super.key,
    required this.progress,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onClose,
                icon: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 10.h,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    color: const Color(0xFFD4AF37),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Text(
                '${currentIndex + 1}/$totalQuestions',
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
