import 'package:arabic/core/model/lang/languages_response.dart';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/auth/data/model/body/sign_in_request_body.dart';
import 'package:arabic/features/auth/data/model/body/sign_up_request_body.dart';
import 'package:arabic/features/auth/data/model/response/auth_response.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class AuthRepo {
  Future<Either<AppException, AuthResponse>> signIn({
    required SignInRequestBody requestBody,
  });
  Future<Either<AppException, AuthResponse>> signUp({
    required SignUpRequestBody requestBody,
  });
  Future<Either<AppException, LanguagesResponse>> getLanguages();
}

class AuthRepoImpl implements AuthRepo {
  final ApiService _apiService;

  AuthRepoImpl(this._apiService);

  @override
  Future<Either<AppException, AuthResponse>> signIn({
    required SignInRequestBody requestBody,
  }) async {
    try {
      final response = await _apiService.post(
        AppURL.signIn,
        data: requestBody.toJson(),
      );
      return Right(AuthResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<AppException, AuthResponse>> signUp({
    required SignUpRequestBody requestBody,
  }) async {
    try {
      // Create FormData for multipart request
      final formData = FormData.fromMap(requestBody.toFormData());

      // Add image file as multipart if provided
      if (requestBody.imageFile != null) {
        formData.files.add(
          MapEntry(
            'ImageFile',
            await MultipartFile.fromFile(
              requestBody.imageFile!.path,
              filename: requestBody.imageFile!.path.split('/').last,
            ),
          ),
        );
      }

      final response = await _apiService.post(AppURL.signUp, data: formData);
      return Right(AuthResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  @override
  Future<Either<AppException, LanguagesResponse>> getLanguages() async {
    try {
      final response = await _apiService.get(endpoint: AppURL.language);
      return Right(LanguagesResponse.fromJson(response.data));
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
