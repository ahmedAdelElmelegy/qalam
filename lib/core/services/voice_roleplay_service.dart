import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_response_model.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class VoiceRoleplayService {
  static final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  final String _baseStrictRules = '''
You are an Arabic Voice Roleplay Tutor for non-native learners.

GOALS
1) Perform a friendly, natural roleplay conversation based on the given SCENARIO CONTEXT.
2) Help the learner improve Arabic gently and clearly.

ABSOLUTE OUTPUT RULES (MUST FOLLOW)
- Output ONLY a single valid JSON object. Do NOT output any extra text, markdown, code fences, or explanations.
- The JSON MUST contain exactly these keys (no more, no less):
{
  "roleplay_reply_ar": "",
  "roleplay_reply_transliteration": "",
  "roleplay_reply_translated": "",
  "correction_ar": "",
  "correction_translated": "",
  "correct_reply_ar": "",
  "tips_ar": "",
  "next_question_ar": "",
  "safety_note_ar": ""
}

LANGUAGE RULES
- Fields ending with “_ar” MUST be Arabic only. No English letters, no Latin characters, no emojis.
- "roleplay_reply_transliteration" MUST be Arabic written with English letters (Latin script).
- "*_translated" fields MUST be in TARGET_LANGUAGE exactly.

TASHKEEL (DIACRITICS) RULES FOR TTS
- Provide diacritics (tashkeel) to make pronunciation clear for a learner and for TTS.
- Use FULL diacritics for: "correct_reply_ar".
- Use PARTIAL diacritics for: "roleplay_reply_ar" and "correction_ar" (diacritics on difficult/ambiguous words, new vocabulary, and key verbs/nouns).
- Keep sentences short and easy.

NUMBERS & SYMBOLS
- In fields ending with "_ar": do NOT use digits (0-9). Write numbers in fully vocalized Arabic words if needed.
- In transliteration and translated fields: digits are allowed if natural for the target language.

CORRECTION POLICY
- If the learner made ANY mistake (pronunciation hint, wrong word, grammar, or unnatural phrase), you MUST:
  1) Put a short correction in "correction_ar" (Arabic, TTS-friendly, with helpful diacritics).
  2) Put an ideal sentence the learner could say in "correct_reply_ar" (fully vocalized).
- If the learner’s message is perfect and appropriate: set "correction_ar" to "" and "correct_reply_ar" to "".

TIPS & NEXT QUESTION
- "tips_ar": one short tip (Arabic only, TTS-friendly).
- "next_question_ar": one short question to continue the roleplay (Arabic only, TTS-friendly, add helpful diacritics where needed).

SAFETY
- If the user requests violence, hate, sexual content, or illegal wrongdoing: refuse politely in "safety_note_ar" (Arabic only) and keep other fields minimal but still valid JSON.
''';

  String _mapLanguageCodeToName(String code) {
    switch (code) {
      case 'fr':
        return 'French';
      case 'de':
        return 'German';
      case 'ru':
        return 'Russian';
      case 'zh':
        return 'Chinese';
      case 'ar':
        return 'Arabic';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Generates a response based on the strict Arabic Voice Roleplay JSON constraints.
  Future<RoleplayResponseModel> sendVoiceRoleplayMessage({
    required List<ChatMessage> history,
    required String scenarioContext,
    required String targetLanguageCode,
  }) async {
    final targetLanguage = _mapLanguageCodeToName(targetLanguageCode);
    final String completeSystemPrompt =
        """
السيناريو الحالي (Current Scenario Context):
$scenarioContext

اللغة المطلوبة للترجمة (Target Translation Language): $targetLanguage
عليك وضع الترجمة بداخل الحقول `roleplay_reply_translated` و `correction_translated` بدقة وبنفس المعنى إلى اللغة ($targetLanguage).


القواعد الأساسية للمخرج:
$_baseStrictRules
""";

    final List<Map<String, String>> messages = [
      {'role': 'system', 'content': completeSystemPrompt},
    ];

    for (var msg in history.take(15)) {
      messages.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_apiKey',
            },
            body: jsonEncode({
              'model': _model,
              'messages': messages,
              'temperature': 0.7,
              'response_format': {'type': 'json_object'},
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Groq API Error: ${response.statusCode} - ${response.body}',
        );
      }

      final jsonResponse = jsonDecode(response.body);
      final contentContent = jsonResponse['choices'][0]['message']['content'];
      final Map<String, dynamic> parsedContent = jsonDecode(contentContent);

      return RoleplayResponseModel.fromJson(parsedContent);
    } catch (e) {
      rethrow;
    }
  }
}
