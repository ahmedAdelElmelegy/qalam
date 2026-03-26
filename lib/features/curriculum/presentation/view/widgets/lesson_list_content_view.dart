import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_header.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/unit_header.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_path_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/unit_quiz_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_final_quiz_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/path_painter.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_list_models.dart';

class LessonListContentView extends StatelessWidget {
  final CurriculumLevel activeLevel;
  final List<LessonListItem> items;
  final int lessonCount;
  final int quizNodeCount;

  const LessonListContentView({
    super.key,
    required this.activeLevel,
    required this.items,
    required this.lessonCount,
    required this.quizNodeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  LevelHeader(activeLevel: activeLevel),
                  Expanded(
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: PathPainter(
                              lessonCount: lessonCount + quizNodeCount,
                            ),
                          ),
                        ),
                        CustomScrollView(
                          physics: const BouncingScrollPhysics(),
                          slivers: [
                            SliverPadding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 40.h,
                              ),
                              sliver: SliverList.builder(
                                itemCount: items.length,
                                itemBuilder: (context, i) {
                                  final item = items[i];
                                  return switch (item) {
                                    UnitHeaderItem(:final unit) => UnitHeader(unit: unit),
                                    LessonItemNode(:final lesson, :final globalIndex, :final levelId, :final unitId) =>
                                      LessonPathNode(
                                        lesson: lesson,
                                        index: globalIndex,
                                        isLeft: globalIndex % 2 == 0,
                                        levelId: levelId,
                                        unitId: unitId,
                                      ),
                                    QuizItemNode(:final quiz, :final globalIndex, :final levelId, :final unitId, :final isUnitCompleted, :final isLocked) =>
                                      UnitQuizNode(
                                        quiz: quiz,
                                        index: globalIndex,
                                        isLeft: globalIndex % 2 == 0,
                                        levelId: levelId,
                                        unitId: unitId,
                                        isUnitCompleted: isUnitCompleted,
                                        isLocked: isLocked,
                                      ),
                                    FinalQuizItemNode(:final quiz, :final levelId, :final isAllUnitsCompleted, :final globalIndex) =>
                                      LevelFinalQuizNode(
                                        quiz: quiz,
                                        levelId: levelId,
                                        isAllUnitsCompleted: isAllUnitsCompleted,
                                        index: globalIndex,
                                      ),
                                    LoadingItemNode(:final globalIndex) => _buildLoadingItem(globalIndex),
                                    SpacerItemNode(:final height) => SizedBox(height: height),
                                  };
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingItem(int globalIndex) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.h),
      child: Row(
        mainAxisAlignment: globalIndex % 2 == 0 ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (globalIndex % 2 != 0) const Spacer(),
          Column(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.2),
              ),
              SizedBox(height: 8.h),
              Container(
                width: 140.w,
                height: 64.h,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ).animate(onPlay: (c) => c.repeat()).shimmer(
                duration: 1200.ms,
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ],
          ),
          if (globalIndex % 2 == 0) const Spacer(),
        ],
      ),
    );
  }
}
