import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/clothing/data/models/clothing_model.dart';
import 'package:dartz/dartz.dart';

class ClothingRepository {
  final ApiService _apiService;

  ClothingRepository(this._apiService);

  Future<Either<AppException, ClothingData>> loadClothing() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.clothing);
      return Right(ClothingData.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
