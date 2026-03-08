import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/lesson_model.dart';
import 'package:arabic/features/curriculum/data/repo/lesson_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lesson_state.dart';

class LessonCubit extends Cubit<LessonState> {
  final LessonRepo lessonRepo;
  LessonCubit(this.lessonRepo) : super(LessonInitial());

  /// Map of unitId to its list of lessons
  final Map<int, List<LessonModel>> unitLessons = {};
  final Set<int> _loadingUnits = {};
  String? _currentLang;

  Future<void> getLessons({required int unitId, required String lang}) async {
    // If language changed, clear all lesson caches
    if (_currentLang != null && _currentLang != lang) {
      unitLessons.clear();
    }
    _currentLang = lang;

    if (unitLessons.containsKey(unitId)) {
      emit(LessonSucess(timestamp: DateTime.now().millisecondsSinceEpoch));
      return;
    }

    if (_loadingUnits.contains(unitId)) return;

    _loadingUnits.add(unitId);
    emit(LessonLoading());

    try {
      final result = await lessonRepo.getLessons(unitId);
      result.fold(
        (l) {
          _loadingUnits.remove(unitId);
          emit(LessonFailed(l));
        },
        (r) {
          unitLessons[unitId] = r;
          _loadingUnits.remove(unitId);
          emit(LessonSucess(timestamp: DateTime.now().millisecondsSinceEpoch));
        },
      );
    } catch (e) {
      _loadingUnits.remove(unitId);
      emit(LessonFailed(ApiErrorHandler.handleError(e)));
    }
  }

  /// Helper to get lessons for a specific unit id if they exist
  List<LessonModel>? getLessonsForUnit(int unitId) => unitLessons[unitId];

  /// Check if a unit is currently loading its lessons
  bool isUnitLoading(int unitId) => _loadingUnits.contains(unitId);

  void clearCache() {
    unitLessons.clear();
    _currentLang = null;
    emit(LessonInitial());
  }
}
