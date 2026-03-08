class RoleplayResponseModel {
  final String roleplayReplyAr;
  final String roleplayReplyTransliteration;
  final String roleplayReplyTranslated;
  final String correctionAr;
  final String correctionTranslated;
  final String correctReplyAr;
  final String tipsAr;
  final String nextQuestionAr;
  final String safetyNoteAr;

  RoleplayResponseModel({
    required this.roleplayReplyAr,
    required this.roleplayReplyTransliteration,
    required this.roleplayReplyTranslated,
    required this.correctionAr,
    required this.correctionTranslated,
    required this.correctReplyAr,
    required this.tipsAr,
    required this.nextQuestionAr,
    required this.safetyNoteAr,
  });

  factory RoleplayResponseModel.fromJson(Map<String, dynamic> json) {
    return RoleplayResponseModel(
      roleplayReplyAr: json['roleplay_reply_ar'] ?? '',
      roleplayReplyTransliteration: json['roleplay_reply_transliteration'] ?? '',
      roleplayReplyTranslated: json['roleplay_reply_translated'] ?? '',
      correctionAr: json['correction_ar'] ?? '',
      correctionTranslated: json['correction_translated'] ?? '',
      correctReplyAr: json['correct_reply_ar'] ?? '',
      tipsAr: json['tips_ar'] ?? '',
      nextQuestionAr: json['next_question_ar'] ?? '',
      safetyNoteAr: json['safety_note_ar'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roleplay_reply_ar': roleplayReplyAr,
      'roleplay_reply_transliteration': roleplayReplyTransliteration,
      'roleplay_reply_translated': roleplayReplyTranslated,
      'correction_ar': correctionAr,
      'correction_translated': correctionTranslated,
      'correct_reply_ar': correctReplyAr,
      'tips_ar': tipsAr,
      'next_question_ar': nextQuestionAr,
      'safety_note_ar': safetyNoteAr,
    };
  }
}
