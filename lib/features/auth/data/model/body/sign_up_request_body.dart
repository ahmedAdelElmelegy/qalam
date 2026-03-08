import 'dart:io';

class SignUpRequestBody {
  final String fullName;
  final String email;
  final String password;
  final int nativeLanguageId;
  final String learningGoal;
  final String country;
  final int age;
  final File? imageFile;

  SignUpRequestBody({
    required this.fullName,
    required this.email,
    required this.password,
    required this.nativeLanguageId,
    required this.learningGoal,
    required this.country,
    required this.age,
    this.imageFile,
  });

  factory SignUpRequestBody.fromJson(Map<String, dynamic> json) {
    return SignUpRequestBody(
      fullName: json['FullName'] ?? '',
      email: json['Email'] ?? '',
      password: json['Password'] ?? '',
      nativeLanguageId: json['NativeLanguageId'] ?? 1,
      learningGoal: json['LearningGoal'] ?? '',
      country: json['Country'] ?? '',
      age: json['Age'] ?? 0,
      imageFile: null, // File cannot be deserialized from JSON
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'FullName': fullName,
      'Email': email,
      'Password': password,
      'NativeLanguageId': nativeLanguageId,
      'LearningGoal': learningGoal,
      'Country': country,
      'Age': age,
      // ImageFile cannot be serialized to JSON
    };
  }

  /// Convert to multipart form data for API request
  Map<String, String> toFormData() {
    return {
      'FullName': fullName,
      'Email': email,
      'Password': password,
      'NativeLanguageId': nativeLanguageId.toString(),
      'LearningGoal': learningGoal,
      'Country': country,
      'Age': age.toString(),
      // ImageFile is handled separately as multipart in repository
    };
  }
}
