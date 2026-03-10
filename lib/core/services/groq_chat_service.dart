import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:arabic/features/chat/data/models/chat_model.dart';
import 'package:arabic/features/chat/data/models/chat_message_model.dart'
    as penpal;

import 'package:flutter_dotenv/flutter_dotenv.dart';

class GroqChatService {
  static final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model =
      'llama-3.3-70b-versatile'; // Standard fast Groq model

  /// Generates a response with smart correction if needed.
  Future<Map<String, dynamic>> sendMessage({
    required List<ChatMessage> history,
    RoleplayScenario? scenario,
  }) async {
    final messages = _buildPrompt(history, scenario);

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
      final content = jsonResponse['choices'][0]['message']['content'];
      return jsonDecode(content);
    } catch (e) {
      rethrow;
    }
  }

  // ── AI Penpal Chat Methods (Text Chat Buddy) ─────────────────────────────

  /// Generates AI's response to the user's text chat history (simplified penpal)
  Future<String> getPenpalResponse(
    List<penpal.ChatMessageModel> history,
    String appLanguage,
  ) async {
    try {
      final messages = <Map<String, String>>[
        {
          'role': 'system',
          'content':
              '''You are a friendly, encouraging AI Penpal.
Your goal is to have a natural, engaging text conversation.
RULES:
1. Detect the language the user is using and reply in that same language.
2. Keep your responses short (1-3 sentences maximum).
3. Ask simple questions to keep the conversation going.
4. Match the user's level. If they use simple words, reply simply.
5. If the user explicitly asks for a translation (e.g., "translate this to Arabic" or "ترجم للعربي"), provide the translation accurately.
6. Context: The user is generally learning $appLanguage, but you should prioritize matching their current language of interaction.
''',
        },
      ];

      for (final msg in history) {
        messages.add({
          'role': msg.sender == penpal.MessageSender.user
              ? 'user'
              : 'assistant',
          'content': msg.text,
        });
      }

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
            }),
          )
          .timeout(const Duration(seconds: 30));

      if (response.statusCode != 200) {
        throw Exception('Failed to get chat response: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      final text = jsonResponse['choices'][0]['message']['content'] ?? '';
      return text.toString().trim();
    } catch (e) {
      debugPrint('Error getting chat response: $e');
      throw Exception('Failed to get chat response: $e');
    }
  }


  /// Generates a structured RoleplayScenario based on a user prompt.
  Future<RoleplayScenario> generateScenario(String userPrompt) async {
    final systemPrompt =
        '''
You are an expert curriculum designer for an Arabic learning app.
The user wants to practice Arabic in a specific situation: "$userPrompt".

Your task is to turn this vague idea into a professional Roleplay Scenario.
Requirements:
1. Title: Professional and concise (e.g., "Buying a Coffee").
2. Description: Briefly explains the context.
3. Role AI: The person the AI will play (e.g., "The Barista").
4. Role User: The person the student will play (e.g., "The Customer").
5. Initial Message: A natural Arabic greeting/opening in character.
6. Goal: A clear objective for the user to achieve in the conversation.
7. Target Vocabulary: 4-5 relevant terms/phrases.

OUTPUT FORMAT (JSON ONLY):
{
  "title": "...",
  "description": "...",
  "role_ai": "...",
  "role_user": "...",
  "initial_message": "...",
  "goal": "...",
  "target_vocab": ["...", "..."]
}
''';

    final response = await http
        .post(
          Uri.parse(_baseUrl),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $_apiKey',
          },
          body: jsonEncode({
            'model': _model,
            'messages': [
              {'role': 'system', 'content': systemPrompt},
            ],
            'temperature': 0.8,
            'response_format': {'type': 'json_object'},
          }),
        )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception('Failed to generate scenario: ${response.body}');
    }

    final jsonResponse = jsonDecode(response.body);
    final content = jsonDecode(
      jsonResponse['choices'][0]['message']['content'],
    );

    return RoleplayScenario(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      title: content['title'] ?? 'Custom Scenario',
      description: content['description'] ?? '',
      roleAi: content['role_ai'] ?? 'Tutor',
      roleUser: content['role_user'] ?? 'Student',
      initialMessage:
          content['initial_message'] ?? 'أهلاً بك! كيف يمكنني مساعدتك؟',
      goal: content['goal'] ?? '',
      targetVocab: List<String>.from(content['target_vocab'] ?? []),
    );
  }

  List<Map<String, String>> _buildPrompt(
    List<ChatMessage> history,
    RoleplayScenario? scenario,
  ) {
    String systemPrompt = '';

    if (scenario != null) {
      systemPrompt =
          '''
You are an expert Arabic teacher roleplaying a scenario.
Scenario: ${scenario.title}
Your Role: ${scenario.roleAi}
User Role: ${scenario.roleUser}
AI Goal: ${scenario.goal}
Target Vocabulary: ${scenario.targetVocab.join(', ')}

RULES:
1. Stay in character at all times.
2. Detect the language the user is using and reply in that same language.
3. Keep sentences short and appropriate for the user's level.
4. Provide a helpful hint for the user's next response.
5. If the user asks for a translation, provide it clearly.

OUTPUT FORMAT (JSON):
{
  "ai_message": "Your response in the DETECTED language (Natural and character-appropriate)",
  "help": {
    "hint1": "Brief hint (word or phrase)",
    "hint2": "Sentence structure with blanks",
    "full_answer": "Complete sample answer"
  },
  "extracted_vocab": [
    {"term": "...", "meaning": "...", "example": "..."}
  ]
}
''';
    } else {
      systemPrompt = '''
You are a helpful and friendly language tutor.

RULES:
1. Detect the language the user is using and reply in that same language.
2. If the user asks for a translation, perform it accurately.

OUTPUT FORMAT (JSON):
{
  "ai_message": "Your friendly response in the DETECTED language",
  "extracted_vocab": [
    {"term": "...", "meaning": "...", "example": "..."}
  ]
}
''';
    }

    final List<Map<String, String>> messages = [
      {
        'role': 'system',
        'content': systemPrompt,
      },
    ];

    for (var msg in history.take(10)) {
      messages.add({
        'role': msg.role == MessageRole.user ? 'user' : 'assistant',
        'content': msg.content,
      });
    }

    return messages;
  }
}
