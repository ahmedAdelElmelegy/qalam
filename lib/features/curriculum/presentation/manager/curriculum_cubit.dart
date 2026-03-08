import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/level/level_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class CurriculumState {}

class CurriculumInitial extends CurriculumState {}

class CurriculumLoading extends CurriculumState {}

class CurriculumError extends CurriculumState {
  final String message;
  CurriculumError(this.message);
}

class CurriculumLoaded extends CurriculumState {
  final List<CurriculumLevel> levels;
  final String currentLevelId;

  CurriculumLoaded({required this.levels, required this.currentLevelId});
}

class CurriculumCubit extends Cubit<CurriculumState> {
  final LevelCubit levelCubit;
  final UnitCubit unitCubit;
  final LessonCubit lessonCubit;
  final QuizCubit quizCubit;

  CurriculumCubit({
    required this.levelCubit,
    required this.unitCubit,
    required this.lessonCubit,
    required this.quizCubit,
  }) : super(CurriculumInitial());

  Future<void> buildLevelFromApi(String levelId) async {
    try {
      if (levelCubit.levelList.isEmpty) {
        return;
      }

      // Get completed lessons list from local storage
      final completedCodes = await LocalStorage.getCompletedLessons();

      // Get the active level model
      final apiLevel = levelCubit.levelList.firstWhere(
        (l) => l.code == levelId || l.id.toString() == levelId,
        orElse: () => levelCubit.levelList.first,
      );

      List<CurriculumUnit> curUnits = [];

      // Only process units if UnitCubit has loaded them for this level
      if (unitCubit.state is UnitSucess) {
        // Create a sorted list of units to ensure Unit 58 etc. are at the top
        final sortedUnits = List.from(unitCubit.unitList)
          ..sort((a, b) => a.id.compareTo(b.id));

        for (var u in sortedUnits) {
          final uLessons = lessonCubit.getLessonsForUnit(u.id) ?? [];

          // Sort lessons within the unit by ID as well
          final sortedLessons = List.from(uLessons)
            ..sort((a, b) => a.id.compareTo(b.id));

          final lessonsList = sortedLessons.map((l) {
            final lesson = l.toLesson();
            return _copyLesson(
              lesson,
              isLocked: false,
              isCompleted: completedCodes.contains(lesson.id),
            );
          }).toList();

          curUnits.add(
            _copyUnit(
              u.toCurriculumUnit(),
              lessons: lessonsList,
              isLocked: false,
            ),
          );
        }
      }

      final activeLevel = _copyLevel(
        apiLevel.toCurriculumLevel(),
        units: curUnits,
        isLocked: false,
      );

      // Keep other levels as skeletons so navigation checks work
      final allLevels = levelCubit.levelList.map((l) {
        if (l.code == apiLevel.code || l.id.toString() == apiLevel.code) {
          return activeLevel;
        }
        return l.toCurriculumLevel();
      }).toList();

      emit(CurriculumLoaded(levels: allLevels, currentLevelId: activeLevel.id));
    } catch (e) {
      emit(CurriculumError('Error building curriculum from API: $e'));
    }
  }

  // ---------------------------------------------------------------------------
  // completeLesson
  // Called when a lesson (without a quiz, or after its quiz) is marked done.
  // Unlocks the next lesson in the same unit. If it's the last lesson AND the
  // unit has no quiz, it also unlocks the next unit.
  // ---------------------------------------------------------------------------
  void completeLesson(String levelId, String unitId, String lessonId) {
    if (state is! CurriculumLoaded) return;
    final currentState = state as CurriculumLoaded;

    // Save completion locally
    LocalStorage.saveLessonCompletion(lessonId);

    final updatedLevels = currentState.levels.map((level) {
      if (level.id != levelId) return level;

      final unitIndex = level.units.indexWhere((u) => u.id == unitId);
      if (unitIndex == -1) return level;

      final unit = level.units[unitIndex];
      final lessonIndex = unit.lessons.indexWhere((l) => l.id == lessonId);
      if (lessonIndex == -1) return level;

      final isLastLesson = lessonIndex == unit.lessons.length - 1;

      // Mark the completed lesson and unlock the next one (if any)
      final updatedLessons = unit.lessons.asMap().entries.map((entry) {
        if (entry.key == lessonIndex) {
          return _copyLesson(entry.value, isCompleted: true, isLocked: false);
        }
        if (entry.key == lessonIndex + 1) {
          return _copyLesson(entry.value, isLocked: false);
        }
        return entry.value;
      }).toList();

      final updatedUnits = List<CurriculumUnit>.from(level.units);
      updatedUnits[unitIndex] = _copyUnit(unit, lessons: updatedLessons);

      // If last lesson AND no unit quiz → auto-unlock next unit
      if (isLastLesson && unit.unitQuiz == null) {
        _unlockNextUnitInList(updatedUnits, unitIndex, level.units.length);
      }

      return _copyLevel(level, units: updatedUnits);
    }).toList();

    emit(
      CurriculumLoaded(
        levels: updatedLevels,
        currentLevelId: currentState.currentLevelId,
      ),
    );
  }

  void reset() {
    emit(CurriculumInitial());
  }

  // ---------------------------------------------------------------------------
  // unlockNextUnit
  // Called after a unit quiz is PASSED. Unlocks the next unit (first lesson).
  // If it was the last unit in the level, auto-unlocks the next level.
  // ---------------------------------------------------------------------------
  void unlockNextUnit(String levelId, String currentUnitId) {
    if (state is! CurriculumLoaded) return;
    final currentState = state as CurriculumLoaded;

    final updatedLevels = currentState.levels.map((level) {
      if (level.id != levelId) return level;

      final currentUnitIndex = level.units.indexWhere(
        (u) => u.id == currentUnitId,
      );
      if (currentUnitIndex == -1) return level;

      final updatedUnits = List<CurriculumUnit>.from(level.units);

      // Mark current unit as completed
      updatedUnits[currentUnitIndex] = _copyUnit(
        level.units[currentUnitIndex],
        isCompleted: true,
      );

      // Unlock next unit (first lesson only)
      _unlockNextUnitInList(updatedUnits, currentUnitIndex, level.units.length);

      return _copyLevel(level, units: updatedUnits);
    }).toList();

    emit(
      CurriculumLoaded(
        levels: updatedLevels,
        currentLevelId: currentState.currentLevelId,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // testOutUnit
  // User passed the skip-test for a unit. Mark all lessons complete + unlock
  // next unit.
  // ---------------------------------------------------------------------------
  void testOutUnit(String levelId, String unitId) {
    if (state is! CurriculumLoaded) return;
    final currentState = state as CurriculumLoaded;

    final updatedLevels = currentState.levels.map((level) {
      if (level.id != levelId) return level;

      final unitIndex = level.units.indexWhere((u) => u.id == unitId);
      if (unitIndex == -1) return level;

      final updatedUnits = List<CurriculumUnit>.from(level.units);

      // Mark ALL lessons in the unit as completed
      final unit = updatedUnits[unitIndex];
      final completedLessons = unit.lessons.map((l) {
        LocalStorage.saveLessonCompletion(l.id);
        return _copyLesson(l, isCompleted: true, isLocked: false);
      }).toList();
      updatedUnits[unitIndex] = _copyUnit(
        unit,
        lessons: completedLessons,
        isCompleted: true,
      );

      // Unlock the next unit
      _unlockNextUnitInList(updatedUnits, unitIndex, level.units.length);

      return _copyLevel(level, units: updatedUnits);
    }).toList();

    emit(
      CurriculumLoaded(
        levels: updatedLevels,
        currentLevelId: currentState.currentLevelId,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // unlockNextLevel
  // Called when the test-out or the last unit quiz of the current level is passed.
  // ---------------------------------------------------------------------------
  void unlockNextLevel(String currentLevelId) {
    if (state is! CurriculumLoaded) return;
    final currentState = state as CurriculumLoaded;

    final levelOrder = ['a0', 'a1', 'a2', 'b1', 'b2', 'c1', 'c2'];
    final nextIndex = levelOrder.indexOf(currentLevelId) + 1;

    final updatedLevels = currentState.levels.map((level) {
      if (level.id == currentLevelId) {
        // 1. Mark the current level's units and lessons as all completed and unlocked
        final updatedUnits = level.units.map((unit) {
          final updatedLessons = unit.lessons.map((lesson) {
            LocalStorage.saveLessonCompletion(lesson.id);
            return _copyLesson(lesson, isCompleted: true, isLocked: false);
          }).toList();
          return _copyUnit(
            unit,
            isCompleted: true,
            isLocked: false,
            lessons: updatedLessons,
          );
        }).toList();
        return _copyLevel(level, units: updatedUnits);
      } else if (nextIndex < levelOrder.length &&
          level.id == levelOrder[nextIndex]) {
        // 2. Unlock the NEXT level, its first unit, and the first lesson of that unit
        final updatedUnits = level.units.asMap().entries.map((unitEntry) {
          if (unitEntry.key == 0) {
            final unit = unitEntry.value;
            final updatedLessons = unit.lessons.asMap().entries.map((
              lessonEntry,
            ) {
              if (lessonEntry.key == 0) {
                return _copyLesson(lessonEntry.value, isLocked: false);
              }
              return lessonEntry.value;
            }).toList();
            return _copyUnit(unit, isLocked: false, lessons: updatedLessons);
          }
          return unitEntry.value;
        }).toList();

        return _copyLevel(level, isLocked: false, units: updatedUnits);
      }

      // 3. For all other levels, keep them as they are
      return level;
    }).toList();

    emit(
      CurriculumLoaded(
        levels: updatedLevels,
        currentLevelId: currentState.currentLevelId,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Helper: unlock the unit at [unitIndex + 1] in [units] in-place.
  // ---------------------------------------------------------------------------
  void _unlockNextUnitInList(
    List<CurriculumUnit> units,
    int currentIndex,
    int totalUnits,
  ) {
    if (currentIndex >= totalUnits - 1) return; // no next unit
    final nextIndex = currentIndex + 1;
    final nextUnit = units[nextIndex];
    final updatedLessons = nextUnit.lessons.asMap().entries.map((le) {
      if (le.key == 0) return _copyLesson(le.value, isLocked: false);
      return le.value;
    }).toList();
    units[nextIndex] = _copyUnit(
      nextUnit,
      isLocked: false,
      lessons: updatedLessons,
    );
  }

  // ---------------------------------------------------------------------------
  // getNextNavigation — unchanged logic, but only offers next nav if unlocked
  // ---------------------------------------------------------------------------
  Map<String, dynamic>? getNextNavigation(
    String levelId,
    String unitId,
    String? currentLessonId,
  ) {
    if (state is! CurriculumLoaded) return null;
    final levels = (state as CurriculumLoaded).levels;
    final level = levels.firstWhere(
      (l) => l.id == levelId,
      orElse: () => levels.first,
    );
    final unitIndex = level.units.indexWhere((u) => u.id == unitId);
    if (unitIndex == -1) return null;

    final unit = level.units[unitIndex];

    if (currentLessonId != null) {
      final lessonIndex = unit.lessons.indexWhere(
        (l) => l.id == currentLessonId,
      );
      if (lessonIndex != -1 && lessonIndex < unit.lessons.length - 1) {
        return {
          'levelId': levelId,
          'unitId': unitId,
          'item': unit.lessons[lessonIndex + 1],
        };
      }
      // After last lesson, go to unit quiz if one exists
      if (unit.unitQuiz != null) {
        return {'levelId': levelId, 'unitId': unitId, 'item': unit.unitQuiz};
      }
    }

    // After unit quiz (or last lesson with no quiz), go to next unit's first lesson
    if (unitIndex < level.units.length - 1) {
      final nextUnit = level.units[unitIndex + 1];
      if (nextUnit.lessons.isNotEmpty) {
        return {
          'levelId': levelId,
          'unitId': nextUnit.id,
          'item': nextUnit.lessons.first,
        };
      }
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Copy helpers
  // ---------------------------------------------------------------------------
  CurriculumLevel _copyLevel(
    CurriculumLevel level, {
    List<CurriculumUnit>? units,
    bool? isLocked,
  }) {
    return CurriculumLevel(
      id: level.id,
      dbId: level.dbId,
      title: level.title,
      description: level.description,
      units: units ?? level.units,
      isLocked: isLocked ?? level.isLocked,
      translations: level.translations,
      levelQuiz: level.levelQuiz,
      titleTranslations: level.titleTranslations,
      descriptionTranslations: level.descriptionTranslations,
    );
  }

  CurriculumUnit _copyUnit(
    CurriculumUnit unit, {
    List<Lesson>? lessons,
    bool? isLocked,
    bool? isCompleted,
  }) {
    return CurriculumUnit(
      id: unit.id,
      dbId: unit.dbId,
      title: unit.title,
      description: unit.description,
      lessons: lessons ?? unit.lessons,
      unitQuiz: unit.unitQuiz,
      isCompleted: isCompleted ?? unit.isCompleted,
      isLocked: isLocked ?? unit.isLocked,
      translations: unit.translations,
      titleTranslations: unit.titleTranslations,
      descriptionTranslations: unit.descriptionTranslations,
    );
  }

  Lesson _copyLesson(Lesson lesson, {bool? isCompleted, bool? isLocked}) {
    return Lesson(
      id: lesson.id,
      dbId: lesson.dbId,
      title: lesson.title,
      content: lesson.content,
      type: lesson.type,
      xpReward: lesson.xpReward,
      estimatedMinutes: lesson.estimatedMinutes,
      isCompleted: isCompleted ?? lesson.isCompleted,
      isLocked: isLocked ?? lesson.isLocked,
      quiz: lesson.quiz,
      contentBlocks: lesson.contentBlocks,
      titleTranslations: lesson.titleTranslations,
      explanationTranslations: lesson.explanationTranslations,
      translations: lesson.translations,
    );
  }
}
