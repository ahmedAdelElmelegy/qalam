import 'package:arabic/core/model/lang/language.dart';

/// Languages Response Model
/// Wraps the API response for languages list
class LanguagesResponse {
  final bool success;
  final String message;
  final List<Language> data;

  LanguagesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory LanguagesResponse.fromJson(Map<String, dynamic> json) {
    return LanguagesResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
              ?.map((item) => Language.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data.map((language) => language.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'LanguagesResponse(success: $success, message: $message, languages: ${data.length})';
}
