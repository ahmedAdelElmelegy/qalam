import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/progress/sync_quiz_request_body.dart';
import 'package:dartz/dartz.dart';

class SyncRequestRepo {
  final ApiService apiService;

  SyncRequestRepo({required this.apiService});

  Future<Either<AppException, void>> syncQuiz(
    SyncQuizRequestBody requestBody,
    int userId,
  ) async {
    try {
      await apiService.post(
        '${AppURL.syncQuiz}/$userId',
        data: requestBody.toJson(),
      );
      return right(null);
    } catch (e) {
      return left(ApiErrorHandler.handleError(e));
    }
  }
}
