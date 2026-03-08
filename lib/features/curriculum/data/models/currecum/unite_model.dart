import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class UnitModel {
  final int id;
  final int levelId;
  final String code;
  final Map<String, String> title;
  final Map<String, String> description;
  final bool isLocked;

  UnitModel({
    required this.id,
    required this.levelId,
    required this.code,
    required this.title,
    required this.description,
    required this.isLocked,
  });

  factory UnitModel.fromJson(Map<String, dynamic> json) {
    return UnitModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      levelId: json['levelId'] is int
          ? json['levelId']
          : int.parse(json['levelId'].toString()),
      code: json['code'] ?? '',
      title: _parseLocalizedMap(json['title']),
      description: _parseLocalizedMap(json['description']),
      isLocked: false,
    );
  }

  /// Converts this API model to the [CurriculumUnit] used in the app logic.
  CurriculumUnit toCurriculumUnit() {
    return CurriculumUnit(
      id: code, // Using 'code' (e.g., 'a0_u1') as the main identifier
      dbId: id, // Pass the database integer ID
      title: title['en'] ?? title['ar'] ?? '',
      description: description['en'] ?? description['ar'] ?? '',
      lessons: [], // Lessons are loaded separately
      isLocked: isLocked,
      isCompleted: false, // Default to false
      titleTranslations: title,
      descriptionTranslations: description,
    );
  }
}

Map<String, String> _parseLocalizedMap(dynamic value) {
  if (value == null) return {};
  if (value is String) return {'en': value};
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val.toString()));
  }
  return {};
}
