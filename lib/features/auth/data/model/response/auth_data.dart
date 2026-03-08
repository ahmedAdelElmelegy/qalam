/// Auth Data Model
/// Contains user authentication data including token and user info
class AuthData {
  final String token;
  final String email;
  final String fullName;
  final String nativeLanguageCode;
  final int id;

  AuthData({
    required this.token,
    required this.email,
    required this.fullName,
    required this.nativeLanguageCode,
    required this.id,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      token: json['token'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      nativeLanguageCode: json['nativeLanguageCode'] ?? '',
      id: json['id'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'email': email,
      'fullName': fullName,
      'nativeLanguageCode': nativeLanguageCode,
      'id': id,
    };
  }

  @override
  String toString() => 'AuthData(email: $email, fullName: $fullName)';
}
