import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/model/virsual_gallary_place_model.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/model/virsual_gallary_sentance_model.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_request.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/virual_gallary_ai_sentance_request.dart';
import 'package:dartz/dartz.dart';

abstract class VirtualGallaryRepo {
  Future<Either<AppException, void>> addVirtualGallaryPlace({
    required VirtualGalleryPlaceAiRequest virtualGalleryPlaceAiRequest,
  });
  Future<Either<AppException, void>> addVirtualGallarySentance({
    required VirtualGallerySentenceRequest virtualGallerySentenceRequest,
    required String placeCode,
  });
  Future<Either<AppException, VirtualGallaryPlacesResponse>>
  getVirtualGallaryPlaces();
  Future<Either<AppException, VirtualGallarySentancesResponse>>
  getVirtualGallarySentances({
    required String placeCode,
    int? pageSize,
    int? pageNumber,
  });
}

class VirtualGallaryRepoImpl implements VirtualGallaryRepo {
  final ApiService apiServices;
  VirtualGallaryRepoImpl(this.apiServices);
  @override
  Future<Either<AppException, void>> addVirtualGallaryPlace({
    required VirtualGalleryPlaceAiRequest virtualGalleryPlaceAiRequest,
  }) async {
    try {
      await apiServices.post(
        AppURL.addvirtualGallaryPlace,
        data: virtualGalleryPlaceAiRequest.toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<AppException, void>> addVirtualGallarySentance({
    required VirtualGallerySentenceRequest virtualGallerySentenceRequest,
    required String placeCode,
  }) async {
    try {
      await apiServices.post(
        // Correct endpoint: Museum/Place/{placeCode}/Sentence
        '${AppURL.addvirtualGallaryPlace}/$placeCode/${AppURL.addvirtualGallarySentance}',
        data: virtualGallerySentenceRequest.toJson(),
      );
      return Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<AppException, VirtualGallaryPlacesResponse>>
  getVirtualGallaryPlaces() async {
    try {
      final response = await apiServices.get(
        endpoint: AppURL.getvirtualGallaryPlace,
      );
      return Right(VirtualGallaryPlacesResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<AppException, VirtualGallarySentancesResponse>>
  getVirtualGallarySentances({
    required String placeCode,
    int? pageSize,
    int? pageNumber,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (pageSize != null) queryParams['pageSize'] = pageSize;
      if (pageNumber != null) queryParams['pageNumber'] = pageNumber;

      final response = await apiServices.get(
        endpoint:
            '${AppURL.getvirtualGallaryPlace}/$placeCode/${AppURL.getvirtualGallarySentance}',
        query: queryParams.isEmpty ? null : queryParams,
      );
      return Right(VirtualGallarySentancesResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
