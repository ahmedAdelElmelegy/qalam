import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/quiz_model.dart';
import 'package:arabic/features/curriculum/data/repo/quiz_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final QuizRepo quizRepo;
  QuizCubit(this.quizRepo) : super(QuizInitial());

  /// Cache of lessonId to its quiz
  final Map<int, LessonQuizModel> quizzes = {};
  bool _isLoading = false;
  String? _currentLang;

  Future<void> getLessonQuiz({required int lessonId, required String lang}) async {
    // If language changed, clear cache
    if (_currentLang != null && _currentLang != lang) {
      quizzes.clear();
    }
    _currentLang = lang;

    // 1. Check cache
    if (quizzes.containsKey(lessonId)) {
      emit(QuizSucess(quizzes[lessonId]!));
      return;
    }

    // 2. Prevent concurrent requests
    if (_isLoading) return;

    _isLoading = true;
    emit(QuizLoading());

    try {
      final result = await quizRepo.getLessonQuiz(lessonId);
      result.fold(
        (l) {
          _isLoading = false;
          emit(QuizFailed(l));
        },
        (r) {
          quizzes[lessonId] = r;
          _isLoading = false;
          emit(QuizSucess(r));
        },
      );
    } catch (e) {
      _isLoading = false;
      emit(QuizFailed(ApiErrorHandler.handleError(e)));
    }
  }

  void clearCache() {
    quizzes.clear();
    _currentLang = null;
    emit(QuizInitial());
  }
}
