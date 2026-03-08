import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class LessonQuizModel {
  final int id;
  final String code;
  final double passingScore;
  final List<QuizQuestionModel> questions;

  LessonQuizModel({
    required this.id,
    required this.code,
    required this.passingScore,
    required this.questions,
  });

  factory LessonQuizModel.fromJson(Map<String, dynamic> json) {
    return LessonQuizModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      code: json['code'] ?? '',
      passingScore: (json['passingScore'] as num?)?.toDouble() ?? 0.8,
      questions: (json['questions'] as List? ?? [])
          .map((q) => QuizQuestionModel.fromJson(q))
          .toList(),
    );
  }

  Quiz toDomain() {
    return Quiz(
      id: id.toString(),
      passingScore: passingScore,
      questions: questions.map((q) => q.toDomain()).toList(),
    );
  }
}

class QuizQuestionModel {
  final int id;
  final dynamic task;
  final String type;
  final String? audioUrl;
  final String? phonetic;
  final String? transliteration;
  final List<String> options;
  final String correctAnswer;

  QuizQuestionModel({
    required this.id,
    required this.task,
    required this.type,
    this.audioUrl,
    this.phonetic,
    this.transliteration,
    required this.options,
    required this.correctAnswer,
  });

  factory QuizQuestionModel.fromJson(Map<String, dynamic> json) {
    return QuizQuestionModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      task: json['task'],
      type: json['type'] ?? 'multipleChoice',
      audioUrl: json['audioUrl'] == "true" || json['audioUrl'] == null 
          ? null 
          : json['audioUrl'],
      phonetic: json['phonetic'],
      transliteration: json['transliteration'],
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
    );
  }

  Question toDomain() {
    return Question(
      id: id.toString(),
      text: _parseLocalizedString(task),
      type: _mapType(type),
      options: options,
      correctAnswer: correctAnswer,
      audioUrl: audioUrl,
      phonetic: phonetic,
      textTranslations: _parseLocalizedMap(task),
    );
  }

  QuestionType _mapType(String type) {
    switch (type) {
      case 'speaking':
        return QuestionType.speaking;
      case 'audioOptions':
        return QuestionType.audioOptions;
      case 'listening':
        return QuestionType.listening;
      case 'multipleChoice':
        return QuestionType.multipleChoice;
      case 'matching':
        return QuestionType.matching;
      case 'reorder':
        return QuestionType.reorder;
      case 'fillInTheBlank':
        return QuestionType.fillInTheBlank;
      default:
        return QuestionType.multipleChoice;
    }
  }

  static Map<String, String> _parseLocalizedMap(dynamic value) {
    if (value == null) return {};
    if (value is String) return {'en': value, 'ar': value};
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val.toString()));
    }
    return {};
  }

  static String _parseLocalizedString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map) {
      return value['en']?.toString() ??
          value['ar']?.toString() ??
          value.values.firstWhere((e) => e != null, orElse: () => '').toString();
    }
    return value.toString();
  }
}
