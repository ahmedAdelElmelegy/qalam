import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_content_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/quiz/quiz_body.dart';

class QuizResultScreen extends StatelessWidget {
  final int score;
  final int quizLength;
  final double passingScore;
  final String levelId;
  final String unitId;
  final String? lessonId;
  final int? quizLessonId;

  const QuizResultScreen({
    super.key,
    required this.score,
    required this.quizLength,
    required this.passingScore,
    required this.levelId,
    required this.unitId,
    this.lessonId,
    this.quizLessonId,
  });

  @override
  Widget build(BuildContext context) {
    final success = score / quizLength >= passingScore;
    final nextNav = success
        ? context.read<CurriculumCubit>().getNextNavigation(
              levelId,
              unitId,
              lessonId,
            )
        : null;
    final nextItem = nextNav?['item'];

    String buttonText = 'quiz_finish'.tr();
    if (success && nextItem != null) {
      buttonText = nextItem is Lesson
          ? 'quiz_next_lesson'.tr()
          : 'quiz_final_challenge'.tr();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: success
                    ? const Color(0xFFD4AF37).withValues(alpha: 0.1)
                    : Colors.white.withValues(alpha: 0.05),
              ),
              child: Icon(
                success
                    ? Icons.emoji_events_rounded
                    : Icons.sentiment_very_dissatisfied_rounded,
                size: 100.w,
                color: success ? const Color(0xFFD4AF37) : Colors.grey,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .shimmer(
                  duration: 2000.ms,
                  color: success ? Colors.white54 : Colors.transparent,
                )
                .scale(
                  begin: const Offset(0.9, 0.9),
                  end: const Offset(1.1, 1.1),
                  duration: 1500.ms,
                  curve: Curves.easeInOut,
                ),
            SizedBox(height: 32.h),
            Text(
              success ? 'quiz_passed'.tr() : 'quiz_failed'.tr(),
              style: AppTextStyles.h1.copyWith(
                color: Colors.white,
                letterSpacing: 2,
                fontWeight: FontWeight.w900,
              ),
            ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),
            SizedBox(height: 12.h),
            Text(
              'quiz_score'.tr(args: ['$score', '$quizLength']),
              style: AppTextStyles.h4.copyWith(
                color: success ? const Color(0xFF10B981) : Colors.white70,
                fontWeight: FontWeight.bold,
              ),
            ).animate().fadeIn(delay: 400.ms),
            SizedBox(height: 60.h),
            if (success)
              Text(
                'quiz_xp_earned'.tr(
                  args: ['${lessonId != null ? 10 : 50}'],
                ),
                style: TextStyle(
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 3,
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                ),
              ).animate().fadeIn(delay: 800.ms).scale(),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w),
              child: ElevatedButton(
                onPressed: () {
                  if (success && nextItem != null) {
                    Navigator.pop(context); // Pop QuizBody
                    if (lessonId != null) {
                      Navigator.pop(context); // Pop LessonContentScreen
                    }

                    if (nextItem is Lesson) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LessonContentScreen(
                            lesson: nextItem,
                            levelId: nextNav!['levelId'],
                            unitId: nextNav['unitId'],
                          ),
                        ),
                      );
                    } else if (nextItem is Quiz) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizBody(
                            quiz: nextItem,
                            levelId: nextNav!['levelId'],
                            unitId: nextNav['unitId'],
                          ),
                        ),
                      );
                    }
                  } else {
                    Navigator.pop(context);
                    if (success && lessonId != null) {
                      Navigator.pop(context);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  minimumSize: Size(double.infinity, 60.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: AppTextStyles.h4.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
