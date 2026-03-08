import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/city/data/models/city_model.dart';
import 'package:dartz/dartz.dart';

class CityRepository {
  final ApiService _apiService;

  CityRepository(this._apiService);

  Future<Either<AppException, CityData>> loadCities() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.cities);
      return Right(CityData.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
