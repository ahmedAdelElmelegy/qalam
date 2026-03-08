import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/quiz_model.dart';
import 'package:dartz/dartz.dart';

class QuizRepo {
  final ApiService apiService;
  QuizRepo(this.apiService);

  Future<Either<AppException, LessonQuizModel>> getLessonQuiz(
    int lessonId,
  ) async {
    try {
      final response = await apiService.get(
        endpoint: '${AppURL.getQuiz}/$lessonId',
      );

      final data = response.data['data'];
      final quiz = LessonQuizModel.fromJson(data);

      return right(quiz);
    } catch (e) {
      return left(ApiErrorHandler.handleError(e));
    }
  }
}
