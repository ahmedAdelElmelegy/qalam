import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqTranslationService {
  static final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  /// Translates [text] from [sourceLanguage] into Arabic.
  /// Returns a Map with 'arabic_response' (Arabic text) and 'translation' (Latin transliteration).
  Future<Map<String, String>> generateConversationalResponse(
    String text, {
    String? sourceLanguage,
  }) async {
    final sourceLang = sourceLanguage ?? 'English';
    final systemPrompt = '''
You are a professional Arabic translator.

YOUR ONLY JOB:
Translate the user's message from $sourceLang into Modern Standard Arabic (فُصْحَى).

RULES:
1. Translate the EXACT meaning. Do NOT paraphrase, summarize, or add words.
2. Preserve all pronouns correctly (I → أنا, you → أنت, he → هو, she → هي, my → ي, your → ك).
3. Keep proper nouns (names, brands, places) unchanged in the Arabic text.
4. If the input is a question, the Arabic output must also be a question.
5. Do NOT output explanations, greetings, or anything except valid JSON.

EXAMPLES:
Input: "can you help me"
Output: {"arabic_response": "هل يمكنك مساعدتي؟", "translation": "hal yumkinuka musa'adati?"}

Input: "my name is Ahmed"
Output: {"arabic_response": "اسمي أحمد", "translation": "ismi Ahmed"}

Input: "hello my friend is Ahmed"
Output: {"arabic_response": "مرحباً، صديقي اسمه أحمد", "translation": "marhaban, sadiqi ismuhu Ahmed"}

OUTPUT FORMAT — return ONLY this JSON, nothing else:
{
  "arabic_response": "<Arabic translation>",
  "translation": "<Latin transliteration of the Arabic>"
}
''';


    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': text},
          ],
          'temperature': 0.0,
          'top_p': 1,
          'max_tokens': 300,
          'response_format': {'type': 'json_object'},
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception(
          'Groq Translation API Error: ${response.statusCode} - ${response.body}',
        );
      }

      final jsonResponse = jsonDecode(response.body);
      final responseContent = jsonResponse['choices'][0]['message']['content'];

      final parsedContent = jsonDecode(responseContent);
      return {
        'arabic_response': parsedContent['arabic_response'] ?? '',
        'translation': parsedContent['translation'] ?? '',
      };
    } catch (e) {
      debugPrint('GroqTranslationService Exception: $e');
      throw Exception('Failed to generate response: $e');
    }
  }
}
