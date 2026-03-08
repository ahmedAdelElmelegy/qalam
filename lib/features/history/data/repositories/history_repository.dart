import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/history/data/models/history_period_model.dart';
import 'package:dartz/dartz.dart';

class HistoryRepository {
  final ApiService _apiService;

  HistoryRepository(this._apiService);

  Future<Either<AppException, HistoryResponse>> loadHistoryData() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.history);
      return Right(HistoryResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
