import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/home/data/model/progress_model.dart';
import 'package:dartz/dartz.dart';

class ProgressRepo {
  final ApiService apis;
  ProgressRepo(this.apis);
  Future<Either<AppException, ProgressModel>> getProgress() async {
    try {
      final response = await apis.get(endpoint: AppURL.getProgress);
      return Right(ProgressModel.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
