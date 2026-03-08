import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/data/models/currecum/quiz_model.dart';

class LessonModel {
  final int id;
  final int unitId;
  final String code;
  final Map<String, String> title;
  final Map<String, String> description; // from 'content' field in JSON
  final List<ContentBlock> structuredContent;
  final int xpReward;
  final int estimatedMinutes;
  final bool isLocked;
  final String type;
  final LessonQuizModel? quiz;

  LessonModel({
    required this.id,
    required this.unitId,
    required this.code,
    required this.title,
    required this.description,
    required this.structuredContent,
    required this.xpReward,
    required this.estimatedMinutes,
    required this.isLocked,
    required this.type,
    this.quiz,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      unitId: json['unitId'] is int
          ? json['unitId']
          : int.parse(json['unitId'].toString()),
      code: json['code'] ?? '',
      title: _parseLocalizedMap(json['title']),
      description: _parseLocalizedMap(json['content']),
      structuredContent: (json['structuredContent'] as List? ?? [])
          .map((b) => ContentBlock.fromJson(b))
          .toList(),
      xpReward: json['xpReward'] ?? 0,
      estimatedMinutes: json['estimatedMinutes'] ?? 0,
      isLocked: false,
      type: json['type'] ?? 'alphabet',
      quiz: json['quiz'] != null ? LessonQuizModel.fromJson(json['quiz']) : null,
    );
  }

  /// Converts this API model to the domain [Lesson] model.
  Lesson toLesson() {
    return Lesson(
      id: code, // UI logic mostly depends on 'code' as ID
      dbId: id, // Pass the database integer ID
      title: title['en'] ?? title['ar'] ?? '',
      content: description['en'] ?? description['ar'] ?? '',
      type: type,
      xpReward: xpReward,
      estimatedMinutes: estimatedMinutes,
      isCompleted: false, // Default state for dynamic loading
      isLocked: false, // Force Unlock
      contentBlocks: structuredContent,
      titleTranslations: title,
      explanationTranslations: description,
      quiz: quiz?.toDomain(),
    );
  }
}

Map<String, String> _parseLocalizedMap(dynamic value) {
  if (value == null) return {};
  if (value is String) return {'en': value, 'ar': value};
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val.toString()));
  }
  return {};
}
