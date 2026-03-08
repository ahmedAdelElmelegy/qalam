import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/traditions/data/models/tradition_model.dart';
import 'package:dartz/dartz.dart';

class TraditionRepository {
  final ApiService _apiService;

  TraditionRepository(this._apiService);

  Future<Either<AppException, TraditionData>> loadTraditions() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.tradition);
      return Right(TraditionData.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
