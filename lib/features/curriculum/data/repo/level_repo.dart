import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/level_model.dart';
import 'package:dartz/dartz.dart';

class LevelRepo {
  ApiService apiService;
  LevelRepo(this.apiService);
  Future<Either<AppException, List<LevelModel>>> getLevels() async {
    try {
      final response = await apiService.get(endpoint: AppURL.getLevels);
      final List<dynamic> data = response.data['data'];
      final List<LevelModel> items = data
          .map((e) => LevelModel.fromJson(e))
          .toList();

      return right(items);
    } catch (e) {
      return left(ApiErrorHandler.handleError(e));
    }
  }
}
