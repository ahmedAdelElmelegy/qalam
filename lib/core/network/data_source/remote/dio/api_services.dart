import 'dart:io';
import 'package:arabic/core/network/api_url/api_endpoints.dart';
import 'package:arabic/core/utils/app_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = AppURL.baseUrl;
  final Dio _dio;
  late String token;
  late String lang;
  final SharedPreferences sharedPreferences;

  ApiService(this._dio, this.sharedPreferences) {
    if (_baseUrl.isEmpty) {
      throw Exception('BASE_URL is not defined in .env');
    }

    _dio
      ..options.baseUrl = _baseUrl
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
      };

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token =
              sharedPreferences.getString(AppConstants.userTOKEN) ?? "";
          final lang = sharedPreferences.getString(AppConstants.lang) ?? "en";

          if (token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          options.headers['lang'] = lang;
          // Also set Accept-Language as a standard
          options.headers['Accept-Language'] = lang;

          return handler.next(options);
        },
      ),
    );
  }

  Future<Response> get({
    required String endpoint,
    Map<String, dynamic>? query,
  }) async {
    try {
      var response = await _dio.get(
        '$_baseUrl$endpoint',
        queryParameters: query,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String endpoint, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.put(
        '$_baseUrl$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String endpoint, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        '$_baseUrl$endpoint',
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> del(
    String endpoint, {
    data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var response = await _dio.delete(
        '$_baseUrl$endpoint',
        queryParameters: queryParameters,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  void updateHeader({String? token}) {
    token = token ?? this.token;
    this.token = token;
    _dio.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  Future<Response> postWithImage(
    String endpoint, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await _dio.post(
        '$_baseUrl$endpoint',
        data: data,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
