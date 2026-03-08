import 'package:dio/dio.dart';

class ApiResponse {
  final Response? response;
  final dynamic error;

  ApiResponse(this.response, this.error);

  ApiResponse.withError(dynamic errorValue)
      : response = null,
        error = errorValue;

  ApiResponse.withSuccess(Response responseValue)
      : response = responseValue,
        error = null;
}

// class Result<T> {
//   final T? data;
//   final AppException? error;
//   final bool isSuccess;

//   Result._({this.data, this.error, required this.isSuccess});

//   factory Result.success(T data) {
//     return Result._(data: data, isSuccess: true);
//   }

//   factory Result.failure(AppException error) {
//     return Result._(error: error, isSuccess: false);
//   }

//   // Helper methods
//   R when<R>({
//     required R Function(T data) success,
//     required R Function(AppException error) failure,
//   }) {
//     if (isSuccess && data != null) {
//       return success(data!);
//     } else {
//       return failure(error!);
//     }
//   }
// }
