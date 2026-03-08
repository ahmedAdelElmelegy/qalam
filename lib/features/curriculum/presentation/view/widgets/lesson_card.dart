import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_content_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/quiz_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final String levelId;
  final String unitId;
  final Color color;
  final String title;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.levelId,
    required this.unitId,
    required this.color,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: lesson.isLocked
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => LessonContentScreen(
                    lesson: lesson,
                    levelId: levelId,
                    unitId: unitId,
                  ),
                ),
              );
            },
      child: Container(
        width: 170.w,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.h4.copyWith(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Icon(Icons.flash_on_rounded, color: Colors.amber, size: 12.w),
                SizedBox(width: 3.w),
                Text(
                  '${lesson.xpReward} XP',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                    fontSize: 10.sp,
                  ),
                ),
                const Spacer(),
                Icon(Icons.timer_outlined, color: Colors.white30, size: 11.w),
                SizedBox(width: 2.w),
                Text(
                  '${lesson.estimatedMinutes}m',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white30,
                    fontSize: 10.sp,
                  ),
                ),
                if (lesson.quiz != null || lesson.dbId != null) ...[
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: lesson.isLocked
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => QuizScreen(
                                  quiz: lesson.quiz,
                                  quizLessonId: lesson.dbId,
                                  lessonId: lesson.id,
                                  levelId: levelId,
                                  unitId: unitId,
                                ),
                              ),
                            );
                          },
                    child: Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: (lesson.isLocked ? Colors.white10 : color)
                            .withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.quiz_rounded,
                        color: lesson.isLocked ? Colors.white10 : color,
                        size: 14.w,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
