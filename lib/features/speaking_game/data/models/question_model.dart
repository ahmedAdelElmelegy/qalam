class QuestionModel {
  final String id;
  final String type; // 'speaking', 'multipleChoice', 'audioOptions', 'listening'
  final String frontText; 
  final String backText; 
  final String correctAnswer;
  final List<String> options; 

  QuestionModel({
    required this.id,
    required this.type,
    required this.frontText,
    required this.backText,
    required this.correctAnswer,
    this.options = const [],
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json, {String locale = 'en'}) {
    String fText = '';
    String bText = '';

    final textNode = json['text'];
    if (textNode is Map<String, dynamic>) {
      fText = textNode[locale] ?? textNode['en'] ?? json['english'] ?? '';
      bText = textNode['ar'] ?? json['arabic'] ?? '';
    } else if (textNode is String) {
      // For speaking/audio types, the text is traditionally the Arabic word
      // But we should try to treat it as the "front" if possible
      fText = textNode;
      bText = textNode;
    }

    // Secondary strategy: check for explicit 'arabic' or 'english' fields
    if (fText.isEmpty) fText = json['english'] ?? '';
    if (bText.isEmpty) bText = json['arabic'] ?? '';

    return QuestionModel(
      id: json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      type: json['type'] ?? 'speaking',
      frontText: fText,
      backText: bText,
      correctAnswer: json['correctAnswer'] ?? bText,
      options: List<String>.from(json['options'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'frontText': frontText,
      'backText': backText,
      'correctAnswer': correctAnswer,
      'options': options,
    };
  }
}
