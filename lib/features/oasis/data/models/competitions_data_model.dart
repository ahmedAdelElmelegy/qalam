import 'dart:convert';
import 'package:flutter/services.dart';

// ─── Level ───────────────────────────────────────────────────────────────────
class CompetitionLevel {
  final String id;
  final String label;
  final String labelAr;
  final int xpRequired;
  final String icon;
  final String color;

  const CompetitionLevel({
    required this.id,
    required this.label,
    required this.labelAr,
    required this.xpRequired,
    required this.icon,
    required this.color,
  });

  factory CompetitionLevel.fromJson(Map<String, dynamic> j) =>
      CompetitionLevel(
        id: j['id'],
        label: j['label'],
        labelAr: j['labelAr'],
        xpRequired: j['xpRequired'],
        icon: j['icon'],
        color: j['color'],
      );
}

// ─── Question Option ─────────────────────────────────────────────────────────
class QuestionOption {
  final String text;
  final bool correct;
  final String feedback;

  const QuestionOption({
    required this.text,
    required this.correct,
    required this.feedback,
  });

  factory QuestionOption.fromJson(Map<String, dynamic> j) => QuestionOption(
        text: j['text'] ?? '',
        correct: j['correct'] ?? false,
        feedback: j['feedback'] ?? '',
      );
}

// ─── Competition Question ─────────────────────────────────────────────────────
class CompetitionQuestion {
  final String id;
  final String type;
  final int xp;

  // Word challenge / riddle fields
  final String? arabic;
  final String? transliteration;
  final String? english;
  final List<String>? options;
  final String? answer;
  final String? hint;
  final String? explanation;

  // Sentence puzzle fields
  final List<String>? words;
  final List<String>? correctOrder;
  final String? wrongSentence;
  final String? correctSentence;

  // Conversation master
  final String? situation;
  final List<QuestionOption>? choiceOptions;

  // Riddle
  final String? riddle;
  final String? riddleEn;
  final String? answerEn;

  // Voice pro
  final String? focusSound;

  const CompetitionQuestion({
    required this.id,
    required this.type,
    required this.xp,
    this.arabic,
    this.transliteration,
    this.english,
    this.options,
    this.answer,
    this.hint,
    this.explanation,
    this.words,
    this.correctOrder,
    this.wrongSentence,
    this.correctSentence,
    this.situation,
    this.choiceOptions,
    this.riddle,
    this.riddleEn,
    this.answerEn,
    this.focusSound,
  });

  factory CompetitionQuestion.fromJson(Map<String, dynamic> j) {
    List<QuestionOption>? choices;
    if (j['options'] is List && j['options'].isNotEmpty && j['options'][0] is Map) {
      choices = (j['options'] as List).map((o) => QuestionOption.fromJson(o)).toList();
    }

    List<String>? stringOptions;
    if (j['options'] is List && (j['options'].isEmpty || j['options'][0] is String)) {
      stringOptions = List<String>.from(j['options'] ?? []);
    }

    return CompetitionQuestion(
      id: j['id'],
      type: j['type'],
      xp: j['xp'] ?? 10,
      arabic: j['arabic'],
      transliteration: j['transliteration'],
      english: j['english'],
      options: stringOptions,
      answer: j['answer'],
      hint: j['hint'],
      explanation: j['explanation'],
      words: j['words'] != null ? List<String>.from(j['words']) : null,
      correctOrder: j['correctOrder'] != null ? List<String>.from(j['correctOrder']) : null,
      wrongSentence: j['wrongSentence'],
      correctSentence: j['correctSentence'],
      situation: j['situation'],
      choiceOptions: choices,
      riddle: j['riddle'],
      riddleEn: j['riddleEn'],
      answerEn: j['answerEn'],
      focusSound: j['focusSound'],
    );
  }
}

// ─── Competition Level Data ───────────────────────────────────────────────────
class CompetitionLevelData {
  final String levelId;
  final int xpReward;
  final int timeLimit;
  final List<CompetitionQuestion> questions;

  const CompetitionLevelData({
    required this.levelId,
    required this.xpReward,
    required this.timeLimit,
    required this.questions,
  });

  factory CompetitionLevelData.fromJson(String levelId, Map<String, dynamic> j) =>
      CompetitionLevelData(
        levelId: levelId,
        xpReward: j['xpReward'] ?? 50,
        timeLimit: j['timeLimit'] ?? 60,
        questions: (j['questions'] as List)
            .map((q) => CompetitionQuestion.fromJson(q))
            .toList(),
      );
}

// ─── Competition Type ─────────────────────────────────────────────────────────
class CompetitionType {
  final String id;
  final String icon;
  final String color;
  final Map<String, CompetitionLevelData> levels;

  const CompetitionType({
    required this.id,
    required this.icon,
    required this.color,
    required this.levels,
  });

  factory CompetitionType.fromJson(Map<String, dynamic> j) {
    final levelsMap = <String, CompetitionLevelData>{};
    (j['levels'] as Map<String, dynamic>).forEach((key, val) {
      levelsMap[key] = CompetitionLevelData.fromJson(key, val);
    });
    return CompetitionType(
      id: j['id'],
      icon: j['icon'],
      color: j['color'],
      levels: levelsMap,
    );
  }

  CompetitionLevelData? getLevel(String levelId) => levels[levelId];
}

// ─── Competitions Data ────────────────────────────────────────────────────────
class CompetitionsData {
  final List<CompetitionLevel> levels;
  final Map<String, CompetitionType> competitions;

  const CompetitionsData({
    required this.levels,
    required this.competitions,
  });

  factory CompetitionsData.fromJson(Map<String, dynamic> j) {
    final compsMap = <String, CompetitionType>{};
    (j['competitions'] as Map<String, dynamic>).forEach((key, val) {
      compsMap[key] = CompetitionType.fromJson(val);
    });
    return CompetitionsData(
      levels: (j['levels'] as List).map((l) => CompetitionLevel.fromJson(l)).toList(),
      competitions: compsMap,
    );
  }
}

// ─── Service ──────────────────────────────────────────────────────────────────
class CompetitionsDataService {
  static CompetitionsData? _cache;

  static Future<CompetitionsData> load() async {
    if (_cache != null) return _cache!;
    final raw = await rootBundle.loadString('assets/data/competitions_data.json');
    _cache = CompetitionsData.fromJson(jsonDecode(raw));
    return _cache!;
  }

  static CompetitionsData? get cached => _cache;

  /// Returns questions for a specific competition type and difficulty level.
  static List<CompetitionQuestion> getQuestions(
      CompetitionsData data, String typeId, String levelId) {
    return data.competitions[typeId]?.getLevel(levelId)?.questions ?? [];
  }

  /// Returns XP reward for completing a level.
  static int getXpReward(CompetitionsData data, String typeId, String levelId) {
    return data.competitions[typeId]?.getLevel(levelId)?.xpReward ?? 0;
  }

  /// Returns time limit in seconds for a competition level.
  static int getTimeLimit(CompetitionsData data, String typeId, String levelId) {
    return data.competitions[typeId]?.getLevel(levelId)?.timeLimit ?? 60;
  }
}
