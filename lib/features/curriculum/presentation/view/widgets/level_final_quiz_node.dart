import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

class LevelFinalQuizNode extends StatelessWidget {
  final Quiz? quiz;
  final String levelId;
  final bool isAllUnitsCompleted;
  final int index;

  const LevelFinalQuizNode({
    super.key,
    this.quiz,
    required this.levelId,
    required this.isAllUnitsCompleted,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final color = const Color(0xFF9B59B6);

    return Column(
          children: [
            Container(
              height: 1,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    color.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      quiz: quiz,
                      levelId: levelId,
                      unitId: '',
                      isLevelQuiz: true,
                    ),
                  ),
                );
              },
              child:
                  Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: color, width: 2.5),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.5),
                              blurRadius: 24,
                              spreadRadius: 4,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.workspace_premium_rounded,
                            color: Colors.white,
                            size: 34.w,
                          ),
                        ),
                      )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.12, 1.12),
                        duration: 1200.ms,
                      ),
            ),
            SizedBox(height: 12.h),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => QuizScreen(
                      quiz: quiz,
                      levelId: levelId,
                      unitId: '',
                      isLevelQuiz: true,
                    ),
                  ),
                );
              },
              child: Container(
                width: 220.w,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(color: color.withValues(alpha: 0.5), width: 1.5),
                ),
                child: Column(
                  children: [
                    Text(
                      'level_exam_title'.tr(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: color,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.8,
                        fontSize: 11.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'level_exam_subtitle'.tr(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        )
        .animate()
        .fadeIn(delay: (200 + index * 80).ms)
        .slideY(begin: 0.15, end: 0);
  }
}
