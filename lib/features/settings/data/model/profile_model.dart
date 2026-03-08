import 'package:equatable/equatable.dart';

class ProfileResponseModel extends Equatable {
  final bool success;
  final String message;
  final ProfileModel? data;

  const ProfileResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ProfileResponseModel.fromJson(Map<String, dynamic> json) {
    return ProfileResponseModel(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: json['data'] != null ? ProfileModel.fromJson(json['data'] as Map<String, dynamic>) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }

  @override
  List<Object?> get props => [success, message, data];
}

class ProfileModel extends Equatable {
  final int id;
  final String fullName;
  final String email;
  final int nativeLanguageId;
  final NativeLanguage nativeLanguage;
  final String learningGoal;
  final String country;
  final int age;
  final String? image;
  final String? imageFile;
  final String createdAt;

  const ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.nativeLanguageId,
    required this.nativeLanguage,
    required this.learningGoal,
    required this.country,
    required this.age,
    this.image,
    this.imageFile,
    required this.createdAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      nativeLanguageId: json['nativeLanguageId'] as int,
      nativeLanguage: NativeLanguage.fromJson(json['nativeLanguage'] as Map<String, dynamic>),
      learningGoal: json['learningGoal'] as String,
      country: json['country'] as String,
      age: json['age'] as int,
      image: json['image'] as String?,
      imageFile: json['imageFile'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'nativeLanguageId': nativeLanguageId,
      'nativeLanguage': nativeLanguage.toJson(),
      'learningGoal': learningGoal,
      'country': country,
      'age': age,
      'image': image,
      'imageFile': imageFile,
      'createdAt': createdAt,
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        email,
        nativeLanguageId,
        nativeLanguage,
        learningGoal,
        country,
        age,
        image,
        imageFile,
        createdAt,
      ];
}

class NativeLanguage extends Equatable {
  final int id;
  final String name;
  final String code;

  const NativeLanguage({
    required this.id,
    required this.name,
    required this.code,
  });

  factory NativeLanguage.fromJson(Map<String, dynamic> json) {
    return NativeLanguage(
      id: json['id'] as int,
      name: json['name'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
    };
  }

  @override
  List<Object?> get props => [id, name, code];
}
