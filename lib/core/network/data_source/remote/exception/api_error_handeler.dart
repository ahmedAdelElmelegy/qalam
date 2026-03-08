import 'dart:io';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
// import 'package:arabic/core/network/models/response/base/error_response.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static AppException handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is SocketException) {
      return NetworkException("No internet connection");
    } else if (error is AppException) {
      return error;
    } else {
      return UnknownException(
        "An unexpected error occurred",
        details: error.toString(),
      );
    }
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.cancel:
        return NetworkException("Request was cancelled");

      case DioExceptionType.connectionTimeout:
        return NetworkException("Connection timeout");

      case DioExceptionType.receiveTimeout:
        return NetworkException("Receive timeout");

      case DioExceptionType.sendTimeout:
        return NetworkException("Send timeout");

      case DioExceptionType.badCertificate:
        return NetworkException("SSL certificate error");

      case DioExceptionType.connectionError:
        if (error.error is SocketException) {
          return NetworkException("No internet connection");
        }
        return NetworkException("Connection error occurred");

      case DioExceptionType.badResponse:
        return _handleBadResponse(error);

      case DioExceptionType.unknown:
        if (error.error is SocketException) {
          return NetworkException("No internet connection");
        }
        return UnknownException(
          "Unknown error occurred",
          details: error.message,
        );
    }
  }

  static AppException _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;

    switch (statusCode) {
      case 400:
        return ValidationException(
          _extractErrorMessage(responseData, "Bad request"),
          code: "400",
          details: responseData,
        );

      case 401:
        return AuthenticationException(
          _extractErrorMessage(responseData, "Email or password is incorrect"),
          code: "401",
          details: responseData,
        );

      case 403:
        return AuthenticationException(
          _extractErrorMessage(responseData, "Access forbidden"),
          code: "403",
        );

      case 404:
        return ServerException("Resource not found", statusCode: 404);

      case 422:
        return ValidationException(
          _extractErrorMessage(responseData, "Validation failed"),
          code: "422",
          details: responseData,
        );

      case 500:
      case 502:
      case 503:
        return ServerException("Server error occurred", statusCode: statusCode);

      default:
        return ServerException(
          "Server error - ${statusCode ?? 'Unknown'}",
          statusCode: statusCode,
          details: responseData,
        );
    }
  }

  static String _extractErrorMessage(
    dynamic responseData,
    String defaultMessage,
  ) {
    if (responseData == null) return defaultMessage;

    try {
      if (responseData is Map) {
        // Try common error message keys
        if (responseData['message'] != null) {
          return responseData['message'].toString();
        }
        if (responseData['error'] != null) {
          return responseData['error'].toString();
        }
        if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          if (errors is Map && errors.isNotEmpty) {
            // Return first error message
            return errors.values.first.toString();
          }
        }
      }
    } catch (e) {
      return defaultMessage;
    }

    return defaultMessage;
  }

  // User-friendly error messages
  static String getUserMessage(AppException exception) {
    if (exception is NetworkException) {
      return "Please check your internet connection and try again";
    } else if (exception is AuthenticationException) {
      return "Email or password is incorrect";
    } else if (exception is ValidationException) {
      return exception.message;
    } else if (exception is ServerException) {
      return "Something went wrong. Please try again later";
    } else {
      return "An unexpected error occurred";
    }
  }
}
