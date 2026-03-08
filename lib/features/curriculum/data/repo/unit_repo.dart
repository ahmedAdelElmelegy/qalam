import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/data/models/currecum/unite_model.dart';
import 'package:dartz/dartz.dart';

class UnitRepo {
  final ApiService apiService;
  UnitRepo(this.apiService);

  Future<Either<AppException, List<UnitModel>>> getUnits(int levelId) async {
    try {
      final response = await apiService.get(
        endpoint: AppURL.getUnits,
        query: {'levelId': levelId},
      );
      
      final List<dynamic> data = response.data['data'];
      final List<UnitModel> items = data
          .map((e) => UnitModel.fromJson(e))
          .toList();

      // Ensure units are always ordered top to bottom by id
      items.sort((a, b) => a.id.compareTo(b.id));

      return right(items);
    } catch (e) {
      return left(ApiErrorHandler.handleError(e));
    }
  }
}
