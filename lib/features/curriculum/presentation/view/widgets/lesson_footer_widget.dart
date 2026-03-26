import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_content_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonFooterWidget extends StatelessWidget {
  final Lesson lesson;
  final String levelId;
  final String unitId;

  const LessonFooterWidget({
    super.key,
    required this.lesson,
    required this.levelId,
    required this.unitId,
  });

  static const _gold = Color(0xFFD4AF37);
  static const _goldLight = Color(0xFFFFE066);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, quizState) {
        Quiz? fetchedQuiz;
        if (quizState is QuizSucess && quizState.quiz.id == lesson.dbId) {
          fetchedQuiz = quizState.quiz.toDomain();
        }

        final quizToPass = fetchedQuiz ?? lesson.quiz;
        final hasQuiz = quizToPass != null && quizToPass.questions.isNotEmpty;

        final isWaitingForQuiz =
            lesson.dbId != null &&
            !hasQuiz &&
            (quizState is QuizInitial || quizState is QuizLoading);

        return Padding(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 36.h),
          child: GestureDetector(
            onTap: isWaitingForQuiz
                ? null
                : () {
                    if (hasQuiz || lesson.dbId != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizScreen(
                            quiz: quizToPass,
                            quizLessonId: lesson.dbId,
                            lessonId: lesson.id,
                            levelId: levelId,
                            unitId: unitId,
                          ),
                        ),
                      );
                    } else {
                      final nextNav = context
                          .read<CurriculumCubit>()
                          .getNextNavigation(levelId, unitId, lesson.id);
                      final nextItem = nextNav?['item'];

                      context
                          .read<CurriculumCubit>()
                          .completeLesson(levelId, unitId, lesson.id);
                      Navigator.pop(context);

                      if (nextItem != null) {
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
                              builder: (_) => QuizScreen(
                                quiz: nextItem,
                                levelId: nextNav!['levelId'],
                                unitId: nextNav['unitId'],
                              ),
                            ),
                          );
                        }
                      }
                    }
                  },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 60.h,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isWaitingForQuiz
                      ? [Colors.grey.shade400, Colors.grey.shade300]
                      : [_gold, _goldLight],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: (isWaitingForQuiz ? Colors.grey : _gold).withValues(
                      alpha: 0.35,
                    ),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Center(
                child: isWaitingForQuiz
                    ? SizedBox(
                        height: 24.h,
                        width: 24.h,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            const Color(0xFF1A1A2E).withValues(alpha: 0.5),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            hasQuiz
                                ? Icons.quiz_rounded
                                : Icons.check_circle_rounded,
                            color: const Color(0xFF1A1A2E),
                            size: 22.w,
                          ),
                          SizedBox(width: 10.w),
                          Text(
                            hasQuiz
                                ? 'Take Lesson Quiz'
                                : 'Complete & Continue',
                            style: AppTextStyles.h4.copyWith(
                              color: const Color(0xFF1A1A2E),
                              fontWeight: FontWeight.w900,
                              fontSize: 17.sp,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 600.ms).scale(
              begin: const Offset(0.95, 0.95),
            );
      },
    );
  }
}
