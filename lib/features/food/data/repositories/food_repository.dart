import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:dartz/dartz.dart';
import '../models/food_model.dart';

class FoodRepository {
  final ApiService _apiService;

  FoodRepository(this._apiService);

  Future<Either<AppException, FoodData>> loadFoodData() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.food);
      return Right(FoodData.fromJson(response.data));
    } catch (e) {
      rethrow;
      // return Left(ApiErrorHandler.handleError(e));
    }
  }
}
