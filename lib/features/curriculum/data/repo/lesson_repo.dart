import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/lesson_model.dart';
import 'package:dartz/dartz.dart';

class LessonRepo {
  final ApiService apiService;
  LessonRepo(this.apiService);

  Future<Either<AppException, List<LessonModel>>> getLessons(int unitId) async {
    try {
      final response = await apiService.get(
        endpoint: AppURL.getLessons,
        query: {'unitId': unitId},
      );

      final List<dynamic> data = response.data['data'];
      final lessons = data.map((json) => LessonModel.fromJson(json)).toList();

      // Ensure lessons are sequentially ordered top-to-bottom
      lessons.sort((a, b) => a.id.compareTo(b.id));

      return right(lessons);
    } catch (e) {
      return left(ApiErrorHandler.handleError(e));
    }
  }
}
