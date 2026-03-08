class SignInRequestBody {
  final String email;
  final String password;

  SignInRequestBody({required this.email, required this.password});

  factory SignInRequestBody.fromJson(Map<String, dynamic> json) {
    return SignInRequestBody(email: json['email'], password: json['password']);
  }

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }
}
