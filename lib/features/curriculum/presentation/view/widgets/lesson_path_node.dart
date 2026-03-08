import 'dart:math' show min;
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_content_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_card.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LessonPathNode extends StatelessWidget {
  final Lesson lesson;
  final int index;
  final bool isLeft;
  final String levelId;
  final String unitId;

  const LessonPathNode({
    super.key,
    required this.lesson,
    required this.index,
    required this.isLeft,
    required this.levelId,
    required this.unitId,
  });

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final title =
        lesson.titleTranslations[locale] ??
        lesson.translations[locale] ??
        lesson.title;
    final statusColor = lesson.isLocked
        ? Colors.grey.withValues(alpha: 0.3)
        : (lesson.isCompleted
              ? const Color(0xFF10B981)
              : const Color(0xFF3B82F6));

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
                        child: _buildNodeIcon(statusColor),
                      ),
                      SizedBox(height: 8.h),
                      LessonCard(
                        lesson: lesson,
                        levelId: levelId,
                        unitId: unitId,
                        color: statusColor,
                        title: title,
                      ),
                    ],
                  ),
                ),
                if (isLeft) const Spacer(),
              ],
            ),
            SizedBox(height: 60.h),
          ],
          // Cap delay so even lesson #100 appears within 400ms
        )
        .animate()
        .fadeIn(delay: (min(index, 4) * 80).ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildNodeIcon(Color color) {
    return Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2),
            boxShadow: [
              if (!lesson.isLocked && !lesson.isCompleted)
                BoxShadow(
                  color: color.withValues(alpha: 0.4),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
            ],
          ),
          child: Center(
            child: Icon(
              lesson.isLocked
                  ? Icons.lock_rounded
                  : (lesson.isCompleted
                        ? Icons.check_rounded
                        : Icons.play_arrow_rounded),
              color: Colors.white,
              size: 24.w,
            ),
          ),
        )
        .animate(
          onPlay: (c) => !lesson.isLocked && !lesson.isCompleted
              ? c.repeat(reverse: true)
              : null,
        )
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.1, 1.1),
          duration: 800.ms,
        );
  }
}
