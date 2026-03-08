import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class LevelModel {
  final int id;
  final String code;
  final Map<String, String> title;
  final Map<String, String> description;
  final bool isLocked;

  LevelModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.isLocked,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      code: json['code'] ?? '',
      title: _parseLocalizedMap(json['title']),
      description: _parseLocalizedMap(json['description']),
      isLocked: false,
    );
  }

  /// Converts this API model to the [CurriculumLevel] used in the app logic.
  CurriculumLevel toCurriculumLevel() {
    return CurriculumLevel(
      id: code, // Using 'code' (e.g., 'a0') as the main identifier
      dbId: id, // The database integer ID
      title: title['en'] ?? title['ar'] ?? '',
      description: description['en'] ?? description['ar'] ?? '',
      units: [], // Units are typically loaded separately
      isLocked: isLocked,
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
