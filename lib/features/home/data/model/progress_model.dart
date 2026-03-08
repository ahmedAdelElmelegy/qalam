import 'package:equatable/equatable.dart';

class ProgressModel extends Equatable {
  final bool success;
  final String message;
  final ProgressData data;

  const ProgressModel({
    required this.success,
    required this.message,
    required this.data,
  });

  ProgressModel.fromJson(Map<String, dynamic> json)
    : success = json['success'],
      message = json['message'],
      data = ProgressData.fromJson(json['data']);

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }

  @override
  List<Object?> get props => [success, message, data];
}

class ProgressData extends Equatable {
  final double percentage;
  final int completedLessonsCount;
  final int totalXp;
  final int activeDays;
  final String? lastSync;

  const ProgressData({
    required this.percentage,
    required this.completedLessonsCount,
    required this.totalXp,
    required this.activeDays,
    this.lastSync,
  });

  ProgressData.fromJson(Map<String, dynamic> json)
      : percentage = (json['percentage'] ?? 0.0).toDouble(),
        completedLessonsCount = json['completedLessonsCount'] ?? 0,
        totalXp = json['totalXp'] ?? 0,
        activeDays = json['activeDays'] ?? 0,
        lastSync = json['lastSync'];

  Map<String, dynamic> toJson() {
    return {
      'percentage': percentage,
      'completedLessonsCount': completedLessonsCount,
      'totalXp': totalXp,
      'activeDays': activeDays,
      'lastSync': lastSync,
    };
  }

  @override
  List<Object?> get props => [
        percentage,
        completedLessonsCount,
        totalXp,
        activeDays,
        lastSync,
      ];
}
