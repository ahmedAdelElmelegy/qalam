import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/data/models/museum_object_model.dart';
import 'package:arabic/core/services/together_ai_image_service.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service to generate unique places using Groq AI
class GroqPlacesService {
  static final String _apiKey = dotenv.env['GROQ_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.groq.com/openai/v1/chat/completions';
  static const String _model = 'llama-3.3-70b-versatile';

  final TogetherAiImageService _imageService = TogetherAiImageService();

  /// Safely converts a dynamic map from JSON into a [Map<String, String>].
  /// Skips entries whose value is null, preventing type-cast errors when
  /// Groq returns partial translations (e.g. `"zh": null`).
  Map<String, String> _safeTexts(dynamic raw) {
    if (raw == null || raw is! Map) return {};
    final result = <String, String>{};
    for (final entry in raw.entries) {
      if (entry.key is String && entry.value != null) {
        result[entry.key as String] = entry.value.toString();
      }
    }
    return result;
  }

  /// Generate a list of unique museum places
  Future<List<MuseumPlaceModel>> generatePlaces({
    required Set<String> previousPlaceNames,
    bool isFirstRequest = false,
  }) async {
    try {
      final int placesToGenerate = isFirstRequest ? 5 : 3;

      final prompt =
          '''
You are a WORLD-CLASS travel curator and linguistic expert.
You generate PHYSICAL, REAL-WORLD places for a language learning app.

ABSOLUTE REALITY & VARIETY RULES:
1. Every place must be a REAL, SPECIFIC physical type of location (e.g., a specific train station, not just "a station").
2. CATEGORY DIVERSITY (MANDATORY): Generate DIFFERENT categories for each place in this batch. Do NOT repeat the same category (e.g., don't generate two restaurants).
3. NO CLONES: Do NOT generate any place whose Arabic name OR English name matches or is very similar to these:
   ${previousPlaceNames.isEmpty ? 'None' : previousPlaceNames.join(' | ')}
4. NO GENERIC MUSEUMS: Unless the place is literally a museum, do NOT use "museum" as a category. If it's a "Station", it must be "train_station".

Generate exactly $placesToGenerate UNIQUE places.

CATEGORIES (choose DIFFERENT ones):
restaurant, cafe, library, museum, park, market, hotel, train_station, street, theater, hospital, gym,
beach, oasis, mountain_trail, archaeological_site, viewpoint

For EACH place generate:
- id: UUID
- category: one from the list above (CRITICAL: Match the category to the place's actual function)
- location: { city, country } (Egypt preferred but varied global cities allowed)
- names: { ar, en, fr, de, zh, ru }
  - CRITICAL: Names MUST be short and concise (1 to 3 words maximum). Do NOT write long descriptive titles.
- short_descriptions: { ar, en, fr, de, zh, ru } (Natural, evocative sentences)

Return ONLY VALID JSON matching:
{
  "places": [
    {
      "id": "uuid",
      "category": "train_station",
      "location": { "city": "Cairo", "country": "Egypt" },
      "names": { "ar": "مَحَطَّةُ مِصْرَ", "en": "Egypt Station", ... },
      "short_descriptions": { "ar": "المَحَطَّةُ الرَّئِيسِيَّةُ لِلْقِطَارَاتِ فِي القَاهِرَةِ.", "en": "The main railway station in Cairo.", ... }
    }
  ]
}
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate places: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      String jsonText = jsonResponse['choices'][0]['message']['content'] ?? '';

      // Clean JSON if needed (though json_object format should be clean)
      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      final jsonData = jsonDecode(jsonText);
      jsonData['places'] as List;

      return Future.wait(
        (jsonData['places'] as List).map((placeData) async {
          final category = placeData['category'] as String? ?? 'museum';

          // Parse basic maps
          final names = _safeTexts(placeData['names']);
          final descriptions = _safeTexts(placeData['short_descriptions']);
          final location = _safeTexts(placeData['location']);

          // Simplified: No nested objects during initial place generation
          final objectsList = <MuseumObjectModel>[];

          final placeName = names['en'] ?? 'Unknown Place';
          final city = location['city'] ?? '';
          final country = location['country'] ?? '';
          final desc = descriptions['en'] ?? '';

          return MuseumPlaceModel(
            id:
                placeData['id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            name: placeName,
            description: desc,
            iconName: _getIconForCategory(category),
            imageUrl: await _imageService.generateImage(
              'A realistic, high-quality photo of a $category in $city, $country. $desc',
            ),
            objects: objectsList,
            category: category,
            location: location,
            localizedNames: names,
            localizedDescriptions: descriptions,
            detailedSentences: {},
          );
        }),
      );
    } catch (e) {
      debugPrint('Error generating places with Groq: $e');
      throw Exception('Failed to generate places: $e');
    }
  }

  Future<List<MuseumObjectModel>> generateSentences({
    required String placeName,
    required String category,
    required List<String> existingSentences,
    int count = 3,
  }) async {
    try {
      final prompt =
          '''
You are a WORLD-CLASS language learning assistant.
Target Place: "$placeName" (Category: $category)

Generate exactly 3 HIGHLY SPECIFIC actions or sentences that happen inside a "$category".
VARIETY RULES:
- These must be CATEGORY-APPROPRIATE. 
  - If $category is "train_station", use travel actions (e.g., "Finding the platform").
  - If $category is "restaurant", use dining actions (e.g., "Asking for the menu").
- DO NOT use generic "Looking at artifacts" unless the category is museum.
- These must be DIFFERENT and UNIQUE from: ${existingSentences.join(' | ')}

Format requirements:
- id: UUID
- icon: Material Icon name (e.g., departure_board, restaurant_menu, etc.)
- texts: Translations in 6 languages (ar, en, fr, de, zh, ru). 
  Arabic MUST NOT include any Tashkeel (diacritics).
- image_keyword: Specific english keyword for image generation.

Return JSON object with "objects" list.
{
  "objects": [
    {
      "id": "uuid",
      "icon": "icon_name1",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    },
    {
      "id": "uuid",
      "icon": "icon_name2",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    },
    {
      "id": "uuid",
      "icon": "icon_name3",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    }
  ]
}
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate sentences: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      String jsonText = jsonResponse['choices'][0]['message']['content'] ?? '';

      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      final jsonData = jsonDecode(jsonText);
      final objectsList = await Future.wait(
        (jsonData['objects'] as List? ?? []).map((objData) async {
          final imageKeyword = objData['image_keyword'] as String? ?? category;
          return MuseumObjectModel(
            id:
                objData['id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            icon: objData['icon'] ?? 'help_outline',
            localizedNames: _safeTexts(objData['texts']),
            imageUrl: await _imageService.generateImage(
              'A realistic photo of $imageKeyword inside a $category',
            ), // Fetch image for the sentence
            // Legacy fields
            arabicName: (objData['texts']?['ar'] as String?) ?? '',
            englishTranslation: (objData['texts']?['en'] as String?) ?? '',
            arabicSentence: '',
            englishSentence: '',
            positionX: 0.5,
            positionY: 0.5,
          );
        }),
      );

      return objectsList;
    } catch (e) {
      debugPrint('Error generating sentences: $e');
      throw Exception('Failed to generate sentences: $e');
    }
  }

  Future<MuseumPlaceModel> generatePlaceByName(String placeName) async {
    try {
      final prompt =
          '''
You are an expert curator and linguistic optimizer. 
The user has provided a place name: "$placeName".

STEP 0: OPTIMIZE INPUT (CRITICAL)
- If "$placeName" is misspelled, incomplete, or formatted poorly (e.g., "egyp staton"), INTERPRET and CORRECT it to the most likely professional version (e.g., "Egypt Station").
- If the user provided a very vague term, expand it into a realistic place (e.g., "coffee" -> "Central Coffee House").
- Use this CORRECTED name for all subsequent fields.

LOGIC STEPS:
1. Categorize: Look at the corrected name. If it contains keywords like "Station", "Cafe", "Restaurant", "Park", "Hospital", use that specific category. 
   - DO NOT default to "museum" unless it's actually a museum.
   - For "Egypt Station", the category MUST be "train_station".
2. Contextualize: Think about what people REALLY do in this specific corrected place. 
   - Generate exactly 3 UNIQUE, category-appropriate actions/interactions.

Format requirements:
- id: UUID
- name: The CORRECTED, professional version of the place name (e.g., "Egypt Station").
- description: A realistic, evocative English description.
- iconName: Material icon name matching the category.
- category: One of: restaurant, cafe, library, museum, park, market, hotel, train_station, street, theater, hospital, gym, beach, oasis, mountain_trail, archaeological_site, viewpoint.
- localizedNames: {"ar": "With Tashkeel", "en": "Corrected English Name", ...}
  - CRITICAL: Names MUST be short and concise (1 to 3 words maximum). Do NOT write long descriptive titles.
- localizedDescriptions: {"ar": "Without Tashkeel", "en": "..."}
- objects: 1 category-specific interaction.
  - texts: {"ar": "Natural text without Tashkeel", "en": "..."}
  - icon: Material icon.
  - image_keyword: English keyword for specific image search.

Arabic text MUST NOT include any Tashkeel (diacritics).

Return JSON object matching:
{
  "id": "uuid",
  "name": "Corrected English Name",
  "description": "...",
  "iconName": "icon",
  "category": "category",
  "localizedNames": {...},
  "localizedDescriptions": {...},
  "objects": [
    {
      "id": "uuid1",
      "icon": "icon_name1",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    },
    {
      "id": "uuid2",
      "icon": "icon_name2",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    },
    {
      "id": "uuid3",
      "icon": "icon_name3",
      "texts": { "ar": "...", "en": "..." },
      "image_keyword": "..."
    }
  ]
}
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate place: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      String jsonText = jsonResponse['choices'][0]['message']['content'] ?? '';
      // Extract JSON if wrapped
      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      final data = jsonDecode(jsonText);

      final objectsList = await Future.wait(
        (data['objects'] as List? ?? []).map((objData) async {
          final imageKeyword = objData['image_keyword'] as String? ?? placeName;
          return MuseumObjectModel(
            id:
                objData['id'] ??
                DateTime.now().millisecondsSinceEpoch.toString(),
            icon: objData['icon'] ?? 'help_outline',
            localizedNames: _safeTexts(objData['texts']),
            imageUrl: await _imageService.generateImage(
              'A realistic photo of $imageKeyword inside $placeName',
            ),
            arabicName: (objData['texts']?['ar'] as String?) ?? '',
            englishTranslation: (objData['texts']?['en'] as String?) ?? '',
            arabicSentence: '',
            englishSentence: '',
            positionX: 0.5,
            positionY: 0.5,
          );
        }),
      );

      final desc = data['description'] ?? '';
      final category = data['category'] ?? 'place';

      return MuseumPlaceModel(
        id: data['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        name: data['name'] ?? placeName,
        description: desc,
        iconName: data['iconName'] ?? 'place',
        imageUrl: await _imageService.generateImage(
          'A realistic, high-quality photo of a $category named $placeName. $desc',
        ),
        objects: objectsList,
        category: category,
        localizedNames: _safeTexts(data['localizedNames']),
        localizedDescriptions: _safeTexts(data['localizedDescriptions']),
      );
    } catch (e) {
      debugPrint('Error generating place by name: $e');
      throw Exception('Failed to generate place: $e');
    }
  }

  Future<MuseumObjectModel> generateSpecificSentence({
    required String placeName,
    required String promptSentence,
  }) async {
    try {
      final prompt =
          '''
You are a WORLD-CLASS language learning assistant and linguistic optimizer.
Context: Place "$placeName".
User Input: "$promptSentence".

STEP 0: OPTIMIZE INPUT (CRITICAL)
- If "$promptSentence" has typos, is incomplete, or phrased poorly (e.g., "i whant a coffie"), CORRECT and OPTIMIZE it to a natural, professional sentence (e.g., "I would like to order a coffee").
- Use this CORRECTED version for all subsequent fields.

Generate a valid action/sentence object.
Format requirements:
- id: UUID
- icon: Material Icon name
- texts: Translations {"ar": "Without Tashkeel", "en": "Corrected English Sentence"}
- image_keyword: Specific english keyword for image search.

Arabic text MUST NOT include any Tashkeel (diacritics).

Return JSON object:
{
  "id": "uuid",
  "icon": "icon_name",
  "texts": { "ar": "...", "en": "..." },
  "image_keyword": "..."
}
''';

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to generate sentence: ${response.body}');
      }

      final jsonResponse = jsonDecode(response.body);
      String jsonText = jsonResponse['choices'][0]['message']['content'] ?? '';

      final firstBrace = jsonText.indexOf('{');
      final lastBrace = jsonText.lastIndexOf('}');
      if (firstBrace != -1 && lastBrace != -1) {
        jsonText = jsonText.substring(firstBrace, lastBrace + 1);
      }

      final objData = jsonDecode(jsonText);
      final imageKeyword = objData['image_keyword'] as String? ?? 'action';

      return MuseumObjectModel(
        id: objData['id'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
        icon: objData['icon'] ?? 'star',
        localizedNames: _safeTexts(objData['texts']),
        imageUrl: await _imageService.generateImage('A photo of $imageKeyword'),
        arabicName: (objData['texts']?['ar'] as String?) ?? '',
        englishTranslation: (objData['texts']?['en'] as String?) ?? '',
        arabicSentence: '',
        englishSentence: '',
        positionX: 0.5,
        positionY: 0.5,
      );
    } catch (e) {
      debugPrint('Error generating specific sentence: $e');
      throw Exception('Failed to generate sentence: $e');
    }
  }

  String _getIconForCategory(String category) {
    category = category.toLowerCase();
    if (category.contains('restaurant') || category.contains('food')) {
      return 'restaurant';
    }
    if (category.contains('cafe') || category.contains('coffee')) {
      return 'coffee';
    }
    if (category.contains('park') || category.contains('garden')) {
      return 'park';
    }
    if (category.contains('market') ||
        category.contains('souq') ||
        category.contains('bazaar')) {
      return 'store';
    }
    if (category.contains('museum') || category.contains('gallery')) {
      return 'museum';
    }
    if (category.contains('mosque') || category.contains('temple')) {
      return 'mosque';
    }
    if (category.contains('library') || category.contains('book')) {
      return 'local_library';
    }
    return 'place';
  }
}
