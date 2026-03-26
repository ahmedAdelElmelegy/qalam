import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';

sealed class LessonListItem {}

class UnitHeaderItem extends LessonListItem {
  final CurriculumUnit unit;
  UnitHeaderItem(this.unit);
}

class LessonItemNode extends LessonListItem {
  final Lesson lesson;
  final int globalIndex;
  final String levelId;
  final String unitId;
  LessonItemNode(this.lesson, this.globalIndex, this.levelId, this.unitId);
}

class QuizItemNode extends LessonListItem {
  final dynamic quiz;
  final int globalIndex;
  final String levelId;
  final String unitId;
  final bool isUnitCompleted;
  final bool isLocked;
  QuizItemNode(
    this.quiz,
    this.globalIndex,
    this.levelId,
    this.unitId,
    this.isUnitCompleted,
    this.isLocked,
  );
}

class FinalQuizItemNode extends LessonListItem {
  final dynamic quiz;
  final String levelId;
  final bool isAllUnitsCompleted;
  final int globalIndex;
  FinalQuizItemNode(
    this.quiz,
    this.levelId,
    this.isAllUnitsCompleted,
    this.globalIndex,
  );
}

class LoadingItemNode extends LessonListItem {
  final int globalIndex;
  LoadingItemNode(this.globalIndex);
}

class SpacerItemNode extends LessonListItem {
  final double height;
  SpacerItemNode(this.height);
}

class LessonListHelper {
  static List<LessonListItem> buildFlatItems(
    CurriculumLevel activeLevel,
    bool Function(int) areLessonsLoadingForUnit,
  ) {
    final items = <LessonListItem>[];
    int globalIndex = 0;
    const isLastUnitUnlockedAndDone = true;

    for (int i = 0; i < activeLevel.units.length; i++) {
      final unit = activeLevel.units[i];
      items.add(UnitHeaderItem(unit));

      if (unit.dbId != null && areLessonsLoadingForUnit(unit.dbId!)) {
        items.add(LoadingItemNode(globalIndex++));
        items.add(LoadingItemNode(globalIndex++));
      } else {
        for (final lesson in unit.lessons) {
          items.add(
            LessonItemNode(
              lesson,
              globalIndex++,
              activeLevel.id.toString(),
              unit.id.toString(),
            ),
          );
        }
      }

      if (unit.unitQuiz != null) {
        items.add(
          QuizItemNode(
            unit.unitQuiz!,
            globalIndex++,
            activeLevel.id.toString(),
            unit.id.toString(),
            false,
            false,
          ),
        );
      }

      if (i < activeLevel.units.length - 1) {
        items.add(SpacerItemNode(40.h));
      }
    }

    if (activeLevel.levelQuiz != null) {
      items.add(SpacerItemNode(40.h));
      items.add(
        FinalQuizItemNode(
          activeLevel.levelQuiz!,
          activeLevel.id.toString(),
          isLastUnitUnlockedAndDone,
          globalIndex,
        ),
      );
    }

    items.add(SpacerItemNode(60.h));
    return items;
  }
}
