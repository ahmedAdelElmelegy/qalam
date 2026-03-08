import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_header.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/unit_header.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_path_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/unit_quiz_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_final_quiz_node.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/path_painter.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';

// ---------------------------------------------------------------------------
// Sealed item types for the flat list used by SliverList.builder
// ---------------------------------------------------------------------------
sealed class _ListItem {}

class _UnitHeaderItem extends _ListItem {
  final CurriculumUnit unit;
  _UnitHeaderItem(this.unit);
}

class _LessonItem extends _ListItem {
  final Lesson lesson;
  final int globalIndex;
  final String levelId;
  final String unitId;
  _LessonItem(this.lesson, this.globalIndex, this.levelId, this.unitId);
}

class _QuizItem extends _ListItem {
  final dynamic quiz;
  final int globalIndex;
  final String levelId;
  final String unitId;
  final bool isUnitCompleted;
  final bool isLocked;
  _QuizItem(
    this.quiz,
    this.globalIndex,
    this.levelId,
    this.unitId,
    this.isUnitCompleted,
    this.isLocked,
  );
}

class _FinalQuizItem extends _ListItem {
  final dynamic quiz;
  final String levelId;
  final bool isAllUnitsCompleted;
  final int globalIndex;
  _FinalQuizItem(
    this.quiz,
    this.levelId,
    this.isAllUnitsCompleted,
    this.globalIndex,
  );
}

class _LoadingItem extends _ListItem {
  final int globalIndex;
  _LoadingItem(this.globalIndex);
}

class _SpacerItem extends _ListItem {
  final double height;
  _SpacerItem(this.height);
}

// ---------------------------------------------------------------------------
// Main Screen
// ---------------------------------------------------------------------------
class LessonListScreen extends StatefulWidget {
  final CurriculumLevel level;

  const LessonListScreen({super.key, required this.level});

  @override
  State<LessonListScreen> createState() => _LessonListScreenState();
}

class _LessonListScreenState extends State<LessonListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.level.dbId != null) {
        context.read<UnitCubit>().getUnits(
          levelId: widget.level.dbId!,
          lang: context.locale.languageCode,
        );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.level.dbId != null) {
      context.read<UnitCubit>().getUnits(
        levelId: widget.level.dbId!,
        lang: context.locale.languageCode,
      );
    }
  }

  /// Builds the flat list of _ListItems from a level — O(n) single pass.
  List<_ListItem> _buildFlatItems(
    CurriculumLevel activeLevel,
    BuildContext context,
  ) {
    final items = <_ListItem>[];
    int globalIndex = 0;
    final lessonCubit = context.read<LessonCubit>();

    const isLastUnitUnlockedAndDone = true; // Force Unlock all quizzes

    for (int i = 0; i < activeLevel.units.length; i++) {
      final unit = activeLevel.units[i];
      items.add(_UnitHeaderItem(unit));

      if (unit.dbId != null &&
          lessonCubit.getLessonsForUnit(unit.dbId!) == null) {
        // Lessons are loading for this unit, show 2 inline skeletons
        items.add(_LoadingItem(globalIndex));
        globalIndex++;
        items.add(_LoadingItem(globalIndex));
        globalIndex++;
      } else {
        for (final lesson in unit.lessons) {
          items.add(_LessonItem(lesson, globalIndex, activeLevel.id, unit.id));
          globalIndex++;
        }
      }

      if (unit.unitQuiz != null) {
        items.add(
          _QuizItem(
            unit.unitQuiz!,
            globalIndex,
            activeLevel.id,
            unit.id,
            false,
            false, // Force Unlock
          ),
        );
        globalIndex++;
      }

      if (i < activeLevel.units.length - 1) {
        items.add(_SpacerItem(40.h));
      }
    }

    if (activeLevel.levelQuiz != null) {
      items.add(_SpacerItem(40.h));
      items.add(
        _FinalQuizItem(
          activeLevel.levelQuiz!,
          activeLevel.id,
          isLastUnitUnlockedAndDone,
          globalIndex,
        ),
      );
    }

    items.add(_SpacerItem(60.h));
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UnitCubit, UnitState>(
          listener: (context, state) {
            if (state is UnitSucess) {
              final unitCubit = context.read<UnitCubit>();
              if (unitCubit.unitList.isEmpty) {
                context.read<CurriculumCubit>().buildLevelFromApi(
                  widget.level.id,
                );
              } else {
                for (var unitModel in unitCubit.unitList) {
                  context.read<LessonCubit>().getLessons(
                    lang: context.locale.languageCode,
                    unitId: unitModel.id,
                  );
                }
              }
            }
          },
        ),
        BlocListener<LessonCubit, LessonState>(
          listener: (context, state) {
            if (state is LessonSucess) {
              final unitCubit = context.read<UnitCubit>();
              if (unitCubit.state is UnitSucess &&
                  unitCubit.unitList.isNotEmpty) {
                context.read<CurriculumCubit>().buildLevelFromApi(
                  widget.level.id,
                );
              }
            }
          },
        ),
      ],
      child: BlocBuilder<CurriculumCubit, CurriculumState>(
        builder: (context, curriculumState) {
          return BlocBuilder<UnitCubit, UnitState>(
            builder: (context, unitState) {
              return BlocBuilder<LessonCubit, LessonState>(
                builder: (context, lessonState) {
                  CurriculumLevel activeLevel = widget.level;

                  if (curriculumState is CurriculumLoaded) {
                    try {
                      activeLevel = curriculumState.levels.firstWhere(
                        (l) => l.id == widget.level.id,
                      );
                    } catch (_) {}
                  }

                  // Fallback: If we have an activeLevel from state but its units are empty, and we are NOT failed, show shimmer
                  final isEffectivelyLoading =
                      unitState is UnitLoading ||
                      unitState is UnitInitial ||
                      (activeLevel.units.isEmpty && unitState is! UnitFailed);

                  // Show error state with retry
                  if (unitState is UnitFailed) {
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
                                    child: Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(32.w),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              unitState.exception
                                                      is NetworkException
                                                  ? Icons.wifi_off_rounded
                                                  : Icons.error_outline_rounded,
                                              color: Colors.redAccent
                                                  .withValues(alpha: 0.8),
                                              size: 48.w,
                                            ),
                                            SizedBox(height: 16.h),
                                            Text(
                                              ApiErrorHandler.getUserMessage(
                                                unitState.exception,
                                              ),
                                              textAlign: TextAlign.center,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: Colors.white,
                                                  ),
                                            ),
                                            SizedBox(height: 24.h),
                                            ElevatedButton(
                                              onPressed: () {
                                                if (widget.level.dbId != null) {
                                                  context
                                                      .read<UnitCubit>()
                                                      .getUnits(
                                                        levelId:
                                                            widget.level.dbId!,
                                                        lang: context
                                                            .locale
                                                            .languageCode,
                                                      );
                                                }
                                              },
                                              child: const Text('Retry'),
                                            ),
                                          ],
                                        ),
                                      ),
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

                  // Show shimmer skeleton while still waiting for data
                  if (isEffectivelyLoading) {
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
                                  const Expanded(child: LessonSkeleton()),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  final allLessons = activeLevel.units
                      .expand((u) => u.lessons)
                      .toList();
                  final items = _buildFlatItems(activeLevel, context);

                  final quizNodeCount = activeLevel.units
                      .where((u) => u.unitQuiz != null)
                      .length;

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
                                      // Path line in background
                                      Positioned.fill(
                                        child: CustomPaint(
                                          painter: PathPainter(
                                            lessonCount:
                                                allLessons.length +
                                                quizNodeCount,
                                          ),
                                        ),
                                      ),
                                      // -----------------------------------------------
                                      // Lazy scrollable list via SliverList.builder
                                      // -----------------------------------------------
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
                                                  _UnitHeaderItem(
                                                    :final unit,
                                                  ) =>
                                                    UnitHeader(unit: unit),
                                                  _LessonItem(
                                                    :final lesson,
                                                    :final globalIndex,
                                                    :final levelId,
                                                    :final unitId,
                                                  ) =>
                                                    LessonPathNode(
                                                      lesson: lesson,
                                                      index: globalIndex,
                                                      isLeft:
                                                          globalIndex % 2 == 0,
                                                      levelId: levelId,
                                                      unitId: unitId,
                                                    ),
                                                  _QuizItem(
                                                    :final quiz,
                                                    :final globalIndex,
                                                    :final levelId,
                                                    :final unitId,
                                                    :final isUnitCompleted,
                                                    :final isLocked,
                                                  ) =>
                                                    UnitQuizNode(
                                                      quiz: quiz,
                                                      index: globalIndex,
                                                      isLeft:
                                                          globalIndex % 2 == 0,
                                                      levelId: levelId,
                                                      unitId: unitId,
                                                      isUnitCompleted:
                                                          isUnitCompleted,
                                                      isLocked: isLocked,
                                                    ),
                                                  _FinalQuizItem(
                                                    :final quiz,
                                                    :final levelId,
                                                    :final isAllUnitsCompleted,
                                                    :final globalIndex,
                                                  ) =>
                                                    LevelFinalQuizNode(
                                                      quiz: quiz,
                                                      levelId: levelId,
                                                      isAllUnitsCompleted:
                                                          isAllUnitsCompleted,
                                                      index: globalIndex,
                                                    ),
                                                  _LoadingItem(
                                                    :final globalIndex,
                                                  ) =>
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                        bottom: 60.h,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            globalIndex % 2 == 0
                                                            ? MainAxisAlignment
                                                                  .start
                                                            : MainAxisAlignment
                                                                  .end,
                                                        children: [
                                                          if (globalIndex % 2 !=
                                                              0)
                                                            const Spacer(),
                                                          Column(
                                                            children: [
                                                              Container(
                                                                    width: 50.w,
                                                                    height:
                                                                        50.w,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.06,
                                                                          ),
                                                                      shape: BoxShape
                                                                          .circle,
                                                                    ),
                                                                  )
                                                                  .animate(
                                                                    onPlay:
                                                                        (
                                                                          controller,
                                                                        ) => controller
                                                                            .repeat(),
                                                                  )
                                                                  .shimmer(
                                                                    duration:
                                                                        1200.ms,
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.2,
                                                                        ),
                                                                  ),
                                                              SizedBox(
                                                                height: 8.h,
                                                              ),
                                                              Container(
                                                                    width:
                                                                        140.w,
                                                                    height:
                                                                        64.h,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white
                                                                          .withValues(
                                                                            alpha:
                                                                                0.06,
                                                                          ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            16.r,
                                                                          ),
                                                                    ),
                                                                  )
                                                                  .animate(
                                                                    onPlay:
                                                                        (
                                                                          controller,
                                                                        ) => controller
                                                                            .repeat(),
                                                                  )
                                                                  .shimmer(
                                                                    duration:
                                                                        1200.ms,
                                                                    color: Colors
                                                                        .white
                                                                        .withValues(
                                                                          alpha:
                                                                              0.2,
                                                                        ),
                                                                  ),
                                                            ],
                                                          ),
                                                          if (globalIndex % 2 ==
                                                              0)
                                                            const Spacer(),
                                                        ],
                                                      ),
                                                    ),
                                                  _SpacerItem(:final height) =>
                                                    SizedBox(height: height),
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
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shimmer skeleton widget (shown while state is resolving)
// ---------------------------------------------------------------------------
class LessonSkeleton extends StatelessWidget {
  const LessonSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
      itemCount: 6,
      itemBuilder: (context, i) {
        return Padding(
          padding: EdgeInsets.only(bottom: 60.h),
          child:
              Row(
                    mainAxisAlignment: i % 2 == 0
                        ? MainAxisAlignment.start
                        : MainAxisAlignment.end,
                    children: [
                      if (i % 2 != 0) const Spacer(),
                      Column(
                        children: [
                          // Circle
                          Container(
                            width: 50.w,
                            height: 50.w,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          // Card
                          Container(
                            width: 140.w,
                            height: 64.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.06),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                        ],
                      ),
                      if (i % 2 == 0) const Spacer(),
                    ],
                  )
                  .animate(onPlay: (c) => c.repeat())
                  .shimmer(
                    duration: 1200.ms,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
        );
      },
    );
  }
}
