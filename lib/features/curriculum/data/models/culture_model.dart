import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

// ─── Content Block Types ─────────────────────────────────────────────────────

enum ContentBlockType { letter, word, sentence }

class LetterForms {
  final String isolated;
  final String initial;
  final String medial;
  final String finalForm;

  const LetterForms({
    required this.isolated,
    required this.initial,
    required this.medial,
    required this.finalForm,
  });

  factory LetterForms.fromJson(Map<String, dynamic> json) {
    return LetterForms(
      isolated: json['isolated'] ?? '',
      initial: json['initial'] ?? '',
      medial: json['medial'] ?? '',
      finalForm: json['final'] ?? '',
    );
  }
}

class SentenceBreakdown {
  final String word;
  final Map<String, String> meaning;

  const SentenceBreakdown({required this.word, required this.meaning});

  factory SentenceBreakdown.fromJson(Map<String, dynamic> json) {
    return SentenceBreakdown(
      word: json['word'] ?? '',
      meaning: _parseLocalizedMap(json['meaning']),
    );
  }
}

abstract class ContentBlock {
  ContentBlockType get type;

  factory ContentBlock.fromJson(Map<String, dynamic> json) {
    final t = json['type'] as String? ?? '';
    switch (t) {
      case 'letter':
      case 'haraka':
      case 'haraka_example':
        return LetterBlock.fromJson(json);
      case 'word':
      case 'form_example':
      case 'connectivity':
        return WordBlock.fromJson(json);
      case 'sentence':
        return SentenceBlock.fromJson(json);
      default:
        return WordBlock.fromJson(json); // fallback
    }
  }
}

class LetterBlock implements ContentBlock {
  @override
  ContentBlockType get type => ContentBlockType.letter;

  final String arabic;
  final Map<String, String> transliterationMap;
  final Map<String, String> soundMap;
  final String? audioUrl;
  final LetterForms? forms;
  final Map<String, String> tip;

  const LetterBlock({
    required this.arabic,
    required this.transliterationMap,
    required this.soundMap,
    this.audioUrl,
    this.forms,
    this.tip = const {},
  });

  factory LetterBlock.fromJson(Map<String, dynamic> json) {
    return LetterBlock(
      arabic: json['arabic'] ?? '',
      transliterationMap: _parseLocalizedMap(json['transliteration']),
      soundMap: _parseLocalizedMap(json['sound']),
      audioUrl: json['audioUrl'],
      forms: json['forms'] != null ? LetterForms.fromJson(json['forms']) : null,
      tip: _parseLocalizedMap(json['tip']),
    );
  }
}

class WordBlock implements ContentBlock {
  @override
  ContentBlockType get type => ContentBlockType.word;

  final String arabic;
  final Map<String, String> transliterationMap;
  final String? audioUrl;
  final String? imageUrl;
  final Map<String, String> translation;
  final String? highlightLetter;

  const WordBlock({
    required this.arabic,
    required this.transliterationMap,
    this.audioUrl,
    this.imageUrl,
    this.translation = const {},
    this.highlightLetter,
  });

  factory WordBlock.fromJson(Map<String, dynamic> json) {
    return WordBlock(
      arabic: json['arabic'] ?? '',
      transliterationMap: _parseLocalizedMap(json['transliteration']),
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'],
      translation: _parseLocalizedMap(json['translation']),
      highlightLetter: json['highlight_letter'],
    );
  }
}

class SentenceBlock implements ContentBlock {
  @override
  ContentBlockType get type => ContentBlockType.sentence;

  final String arabic;
  final Map<String, String> transliterationMap;
  final String? audioUrl;
  final Map<String, String> translation;
  final List<SentenceBreakdown> breakdown;
  final Map<String, String> tip;

  const SentenceBlock({
    required this.arabic,
    required this.transliterationMap,
    this.audioUrl,
    this.translation = const {},
    this.breakdown = const [],
    this.tip = const {},
  });

  factory SentenceBlock.fromJson(Map<String, dynamic> json) {
    return SentenceBlock(
      arabic: json['arabic'] ?? '',
      transliterationMap: _parseLocalizedMap(json['transliteration']),
      audioUrl: json['audioUrl'],
      translation: _parseLocalizedMap(json['translation']),
      breakdown: (json['breakdown'] as List? ?? [])
          .map((b) => SentenceBreakdown.fromJson(b))
          .toList(),
      tip: _parseLocalizedMap(json['tip']),
    );
  }
}

// ─── API Response Models ──────────────────────────────────────────────────────

// ─── Curriculum Models ────────────────────────────────────────────────────────

class CurriculumLevel {
  final String id;
  final int? dbId;
  final String title;
  final String description;
  final List<CurriculumUnit> units;
  final bool isLocked;
  final Map<String, String> translations;
  final Quiz? levelQuiz;
  final Map<String, String> titleTranslations;
  final Map<String, String> descriptionTranslations;

  CurriculumLevel({
    required this.id,
    this.dbId,
    required this.title,
    required this.description,
    required this.units,
    this.isLocked = true,
    this.translations = const {},
    this.levelQuiz,
    this.titleTranslations = const {},
    this.descriptionTranslations = const {},
  });

  factory CurriculumLevel.fromJson(Map<String, dynamic> json) {
    return CurriculumLevel(
      id: json['id'].toString(),
      dbId: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()),
      title: _parseLocalizedString(json['title']),
      description: _parseLocalizedString(json['description']),
      isLocked: json['isLocked'] ?? true,
      units: (json['units'] as List? ?? [])
          .map((u) => CurriculumUnit.fromJson(u))
          .toList(),
      translations: Map<String, String>.from(json['translations'] ?? {}),
      levelQuiz: json['levelQuiz'] != null
          ? Quiz.fromJson(json['levelQuiz'])
          : null,
      titleTranslations: _parseLocalizedMap(json['title']),
      descriptionTranslations: _parseLocalizedMap(json['description']),
    );
  }
}

class CurriculumUnit {
  final String id;
  final int? dbId;
  final String title;
  final String description;
  final List<Lesson> lessons;
  final Quiz? unitQuiz;
  final bool isCompleted;
  final bool isLocked;
  final Map<String, String> translations;
  final Map<String, String> titleTranslations;
  final Map<String, String> descriptionTranslations;

  CurriculumUnit({
    required this.id,
    this.dbId,
    required this.title,
    required this.description,
    required this.lessons,
    this.unitQuiz,
    this.isCompleted = false,
    this.isLocked = true,
    this.translations = const {},
    this.titleTranslations = const {},
    this.descriptionTranslations = const {},
  });

  factory CurriculumUnit.fromJson(Map<String, dynamic> json) {
    return CurriculumUnit(
      id: json['id'].toString(),
      dbId: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()),
      title: _parseLocalizedString(json['title']),
      description: _parseLocalizedString(json['description']),
      lessons: (json['lessons'] as List? ?? [])
          .map((l) => Lesson.fromJson(l))
          .toList(),
      unitQuiz: json['unitQuiz'] != null
          ? Quiz.fromJson(json['unitQuiz'])
          : null,
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? true,
      translations: Map<String, String>.from(json['translations'] ?? {}),
      titleTranslations: _parseLocalizedMap(json['title']),
      descriptionTranslations: _parseLocalizedMap(json['description']),
    );
  }
}

class Lesson {
  final String id;
  final int? dbId;
  final String title;
  final String content; // explanation text (from 'explanation' field)
  final String type;
  final int xpReward;
  final int estimatedMinutes;
  final bool isCompleted;
  final bool isLocked;
  final Quiz? quiz;

  // New typed content blocks (from 'content' array)
  final List<ContentBlock> contentBlocks;

  // Localizations
  final Map<String, String> titleTranslations;
  final Map<String, String> explanationTranslations;
  final Map<String, String> translations;

  Lesson({
    required this.id,
    this.dbId,
    required this.title,
    required this.content,
    this.type = 'alphabet',
    this.xpReward = 10,
    this.estimatedMinutes = 5,
    this.isCompleted = false,
    this.isLocked = true,
    this.quiz,
    this.contentBlocks = const [],
    this.titleTranslations = const {},
    this.explanationTranslations = const {},
    this.translations = const {},
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    // Parse content blocks if the 'content' field is a List
    final rawContent = json['content'];
    List<ContentBlock> blocks = [];
    if (rawContent is List) {
      blocks = rawContent
          .whereType<Map<String, dynamic>>()
          .map((b) => ContentBlock.fromJson(b))
          .toList();
    }

    return Lesson(
      id: json['id'],
      dbId: json['dbId'] is int
          ? json['dbId']
          : int.tryParse(json['dbId']?.toString() ?? ''),
      title: _parseLocalizedString(json['title']),
      content: _parseLocalizedString(
        json['description'] ?? json['explanation'] ?? '',
      ),
      type: json['type'] is String ? json['type'] : 'alphabet',
      xpReward: json['xpReward'] ?? 10,
      estimatedMinutes: json['estimatedMinutes'] ?? 5,
      isCompleted: json['isCompleted'] ?? false,
      isLocked: json['isLocked'] ?? true,
      quiz: json['quiz'] != null ? Quiz.fromJson(json['quiz']) : null,
      contentBlocks: blocks,
      titleTranslations: _parseLocalizedMap(json['title']),
      explanationTranslations: _parseLocalizedMap(
        json['description'] ?? json['explanation'],
      ),
      translations: Map<String, String>.from(json['translations'] ?? {}),
    );
  }
}

// ─── Quiz / Question Models ───────────────────────────────────────────────────

class Quiz {
  final String id;
  final List<Question> questions;
  final double passingScore;

  Quiz({required this.id, required this.questions, this.passingScore = 0.8});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      questions: (json['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList(),
      passingScore: json['passingScore']?.toDouble() ?? 0.8,
    );
  }
}

enum QuestionType {
  multipleChoice,
  reorder,
  matching,
  speaking,
  fillInTheBlank,
  listening,
  audioOptions,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final String correctAnswer;
  final String? audioUrl;
  final String? phonetic;
  final String? imageUrl;
  final Map<String, String>? matchingPairs;
  final Map<String, String> textTranslations;

  Question({
    required this.id,
    required this.text,
    required this.type,
    this.options = const [],
    required this.correctAnswer,
    this.audioUrl,
    this.phonetic,
    this.imageUrl,
    this.matchingPairs,
    this.textTranslations = const {},
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      text: _parseLocalizedString(json['text']),
      type: QuestionType.values.firstWhere(
        (e) => e.toString() == 'QuestionType.${json['type']}',
        orElse: () => QuestionType.multipleChoice,
      ),
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? '',
      audioUrl: json['audioUrl'],
      phonetic: json['phonetic'],
      imageUrl: json['imageUrl'],
      matchingPairs: json['matchingPairs'] != null
          ? Map<String, String>.from(json['matchingPairs'])
          : null,
      textTranslations: _parseLocalizedMap(json['text']),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

Map<String, String> _parseLocalizedMap(dynamic value) {
  if (value == null) return {};
  if (value is String) return {'en': value};
  if (value is Map) {
    return value.map((key, val) => MapEntry(key.toString(), val.toString()));
  }
  return {};
}

String _parseLocalizedString(dynamic value) {
  if (value == null) return '';
  if (value is String) return value;
  if (value is Map) {
    return value['en']?.toString() ??
        value.values.firstWhere((e) => e != null, orElse: () => '').toString();
  }
  return value.toString();
}

String localizedValue(
  Map<String, String> map,
  String locale, {
  String fallbackLocale = 'en',
  required String defaultValue,
}) {
  final v = map[locale];
  if (v != null && v.trim().isNotEmpty) return v;

  final fb = map[fallbackLocale];
  if (fb != null && fb.trim().isNotEmpty) return fb;

  // Only print if the map is empty and we expect a value
  if (map.isEmpty && defaultValue.isEmpty) {
    return defaultValue;
  }

  if (map.isEmpty || (map[locale] == null && map[fallbackLocale] == null)) {
    // debugPrint('No value found for locale $locale in map $map');
  }

  return defaultValue;
}

String getLevelTitle(CurriculumLevel level, BuildContext context) {
  final locale = context.locale.languageCode;
  return localizedValue(
    level.titleTranslations,
    locale,
    defaultValue: level.title,
  );
}

String getLevelDescription(CurriculumLevel level, BuildContext context) {
  final locale = context.locale.languageCode;
  return localizedValue(
    level.descriptionTranslations,
    locale,
    defaultValue: level.description,
  );
}
