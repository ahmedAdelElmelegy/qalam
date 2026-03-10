import 'package:uuid/uuid.dart';

enum MessageRole { user, assistant, system }

class ChatMessage {
  final String id;
  final String content;
  final MessageRole role;
  final DateTime timestamp;
  ChatMessage({
    String? id,
    required this.content,
    required this.role,
    DateTime? timestamp,
  }) : id = id ?? const Uuid().v4(),
       timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'role': role.index,
    'timestamp': timestamp.toIso8601String(),
  };
}


class RoleplayScenario {
  final String id;
  final String title;
  final String description;
  final String roleAi;
  final String roleUser;
  final String initialMessage;
  final String goal;
  final List<String> targetVocab;

  RoleplayScenario({
    required this.id,
    required this.title,
    required this.description,
    required this.roleAi,
    required this.roleUser,
    required this.initialMessage,
    required this.goal,
    required this.targetVocab,
  });
}

class VocabItem {
  final String term;
  final String meaning;
  final String example;
  final int proficiency; // 0-3
  final DateTime lastReviewed;

  VocabItem({
    required this.term,
    required this.meaning,
    required this.example,
    this.proficiency = 0,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'term': term,
    'meaning': meaning,
    'example': example,
    'proficiency': proficiency,
    'lastReviewed': lastReviewed.toIso8601String(),
  };
}
