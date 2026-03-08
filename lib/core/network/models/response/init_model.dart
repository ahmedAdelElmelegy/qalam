import 'package:equatable/equatable.dart';

class InitModel extends Equatable {
  final dynamic data;
  final String? message;
  final int? code;

  const InitModel({this.data, this.message, this.code});

  factory InitModel.fromJson(Map<String, dynamic> json) => InitModel(
        data: json['data'] as dynamic,
        message: json['message'] as String?,
        code: json['code'] as int?,
      );

  Map<String, dynamic> toJson() => {
        'data': data,
        'message': message,
        'code': code,
      };

  @override
  List<Object?> get props => [data, message, code];
}
