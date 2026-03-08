import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/network/data_source/remote/dio/api_services.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/settings/data/model/edit_profile_request_body.dart';
import 'package:arabic/features/settings/data/model/profile_model.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProfileRepo {
  final ApiService apiService;

  ProfileRepo({required this.apiService});

  Future<Either<AppException, ProfileResponseModel>> getProfile(
    int userId,
  ) async {
    try {
      final response = await apiService.get(
        endpoint: '${AppURL.getUserProfile}/$userId',
      );
      return right(ProfileResponseModel.fromJson(response.data));
    } catch (e) {
      // Handle error
      return left(ApiErrorHandler.handleError(e));
    }
  }

  Future<Either<AppException, void>> updateProfile(
    EditProfileRequestBody requestBody,
    int userId,
  ) async {
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

      await apiService.put('${AppURL.getUserProfile}/$userId', data: formData);
      return Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }

  Future<Either<AppException, void>> updateLanguage(
    int languageId,
    ProfileModel currentProfile,
  ) async {
    try {
      final formData = FormData.fromMap({
        'FullName': currentProfile.fullName,
        'Email': currentProfile.email,
        'NativeLanguageId': languageId.toString(),
        'LearningGoal': currentProfile.learningGoal,
        'Country': currentProfile.country,
        'Age': currentProfile.age.toString(),
      });

      await apiService.put(
        '${AppURL.getUserProfile}/${currentProfile.id}',
        data: formData,
      );
      return Right(null);
    } catch (e) {
      return Left(ApiErrorHandler.handleError(e));
    }
  }
}
