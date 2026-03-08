import 'package:arabic/features/auth/data/model/response/auth_data.dart';

/// Auth Response Model
/// Wraps the API response for authentication (sign-in/sign-up)
class AuthResponse {
  final bool success;
  final String message;
  final AuthData data;

  AuthResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AuthData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  String toString() =>
      'AuthResponse(success: $success, message: $message, data: $data)';
}
