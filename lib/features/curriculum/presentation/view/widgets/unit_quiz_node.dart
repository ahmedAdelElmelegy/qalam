import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class UnitQuizNode extends StatelessWidget {
  final Quiz? quiz;
  final int index;
  final bool isLeft;
  final String levelId;
  final String unitId;
  final bool isUnitCompleted;
  final bool isLocked;

  const UnitQuizNode({
    super.key,
    this.quiz,
    required this.index,
    required this.isLeft,
    required this.levelId,
    required this.unitId,
    required this.isUnitCompleted,
    required this.isLocked,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            Row(
              mainAxisAlignment: isLeft
                  ? MainAxisAlignment.start
                  : MainAxisAlignment.end,
              children: [
                if (!isLeft) const Spacer(),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 180.w),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: isLocked
                            ? null
                            : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => QuizScreen(
                                      quiz: quiz,
                                      levelId: levelId,
                                      unitId: unitId,
                                      isSkipQuiz: !isUnitCompleted,
                                    ),
                                  ),
                                );
                              },
                        child: _buildTrophyIcon(isLocked),
                      ),
                      SizedBox(height: 8.h),
                      _buildQuizCard(context, isLocked),
                    ],
                  ),
                ),
                if (isLeft) const Spacer(),
              ],
            ),
            SizedBox(height: 60.h),
          ],
        )
        .animate()
        .fadeIn(delay: (200 + index * 100).ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildTrophyIcon(bool locked) {
    final color = locked
        ? Colors.grey.withValues(alpha: 0.4)
        : const Color(0xFFD4AF37);
    return Container(
          width: 60.w,
          height: 60.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5),
            boxShadow: [
              if (!locked)
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                ),
            ],
          ),
          child: Center(
            child: Icon(
              locked ? Icons.lock_rounded : Icons.emoji_events_rounded,
              color: locked ? Colors.white38 : Colors.white,
              size: 30.w,
            ),
          ),
        )
        .animate(onPlay: (c) => !locked ? c.repeat(reverse: true) : null)
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.15, 1.15),
          duration: 1000.ms,
        );
  }

  Widget _buildQuizCard(BuildContext context, bool locked) {
    final color = locked
        ? Colors.grey.withValues(alpha: 0.3)
        : const Color(0xFFD4AF37);
    return GestureDetector(
      onTap: locked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => QuizScreen(
                    quiz: quiz,
                    levelId: levelId,
                    unitId: unitId,
                    isSkipQuiz: !isUnitCompleted,
                  ),
                ),
              );
            },
      child: Container(
        width: 170.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              'unit_quiz_title'.tr(),
              style: AppTextStyles.bodySmall.copyWith(
                color: color,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              locked ? 'locked_status'.tr() : (isUnitCompleted ? 'completed_status'.tr() : 'test_out_status'.tr()),
              style: AppTextStyles.bodyMedium.copyWith(
                color: locked ? Colors.white38 : Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
