import 'dart:io';

class EditProfileRequestBody {
  final String fullName;
  final String email;
  final int nativeLanguageId;
  final String learningGoal;
  final String country;
  final int age;
  final File? imageFile;

  EditProfileRequestBody({
    required this.fullName,
    required this.email,
    required this.nativeLanguageId,
    required this.learningGoal,
    required this.country,
    required this.age,
    this.imageFile,
  });

  Map<String, String> toFormData() {
    return {
      'FullName': fullName,
      'Email': email,
      'NativeLanguageId': nativeLanguageId.toString(),
      'LearningGoal': learningGoal,
      'Country': country,
      'Age': age.toString(),
    };
  }
}
