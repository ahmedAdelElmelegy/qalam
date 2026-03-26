import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_list_models.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_list_error_view.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_list_loading_view.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_list_content_view.dart';

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
    WidgetsBinding.instance.addPostFrameCallback((_) => _initData());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initData();
  }

  void _initData() {
    if (widget.level.dbId != null) {
      context.read<UnitCubit>().getUnits(
        levelId: widget.level.dbId!,
        lang: context.locale.languageCode,
      );
    }
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
                context.read<CurriculumCubit>().buildLevelFromApi(widget.level.id);
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
              if (unitCubit.state is UnitSucess && unitCubit.unitList.isNotEmpty) {
                context.read<CurriculumCubit>().buildLevelFromApi(widget.level.id);
              }
            }
          },
        ),
      ],
      child: BlocBuilder<CurriculumCubit, CurriculumState>(
        builder: (context, curriculumState) {
          return BlocBuilder<UnitCubit, UnitState>(
            builder: (context, unitState) {
              CurriculumLevel activeLevel = widget.level;
              if (curriculumState is CurriculumLoaded) {
                try {
                  activeLevel = curriculumState.levels.firstWhere((l) => l.id == widget.level.id);
                } catch (_) {}
              }

              final unitFailed = unitState is UnitFailed;
              final isEffectivelyLoading = unitState is UnitLoading ||
                  unitState is UnitInitial ||
                  (activeLevel.units.isEmpty && !unitFailed);

              if (unitFailed) return LessonListErrorView(activeLevel: activeLevel, exception: unitState.exception);
              if (isEffectivelyLoading) return LessonListLoadingView(activeLevel: activeLevel);

              final lessonCubit = context.read<LessonCubit>();
              final items = LessonListHelper.buildFlatItems(activeLevel, (unitId) => lessonCubit.getLessonsForUnit(unitId) == null);
              final allLessonsCount = activeLevel.units.fold<int>(0, (sum, u) => sum + u.lessons.length);
              final quizNodeCount = activeLevel.units.where((u) => u.unitQuiz != null).length;

              return LessonListContentView(
                activeLevel: activeLevel,
                items: items,
                lessonCount: allLessonsCount,
                quizNodeCount: quizNodeCount,
              );
            },
          );
        },
      ),
    );
  }
}
