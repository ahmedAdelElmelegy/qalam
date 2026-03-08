import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'dart:io';

/// Free translation using Lingva Translate (Google Translate quality, no API key).
/// Falls back to MyMemory if Lingva is unavailable.
/// Returns the same Map interface as the old GroqTranslationService.
class MlKitTranslationService {
  // Lingva public instance — backed by Google Translate data
  static const String _lingvaBase = 'https://lingva.ml/api/v1';

  // Map human-readable language names → BCP-47 codes
  static const Map<String, String> _langCodes = {
    'English': 'en',
    'French': 'fr',
    'German': 'de',
    'Spanish': 'es',
    'Russian': 'ru',
    'Chinese': 'zh',
    'Hindi': 'hi',
    'Portuguese': 'pt',
    'Turkish': 'tr',
    'Italian': 'it',
    'Indonesian': 'id',
    'Persian': 'fa',
    'Urdu': 'ur',
    'Arabic': 'ar',
  };

  Future<Map<String, String>> generateConversationalResponse(
    String text, {
    String? sourceLanguage,
  }) async {
    final srcCode = _langCodes[sourceLanguage ?? 'English'] ?? 'en';

    String arabic = '';

    // --- Primary: Lingva Translate (Google Translate quality) ---
    try {
      arabic = await _translateWithLingva(text, srcCode);
    } catch (e) {
      debugPrint('Lingva failed: $e — falling back to MyMemory');
    }

    // --- Fallback: MyMemory ---
    if (arabic.isEmpty) {
      try {
        arabic = await _translateWithMyMemory(text, srcCode);
      } catch (e) {
        debugPrint('MyMemory also failed: $e');
        if (e is DioException || e is SocketException) {
            rethrow;
        }
        throw Exception('All translation providers failed.');
      }
    }

    // Normalize Arabic Presentation Forms (garbled chars like ﻼﻫﺍ → لاها)
    arabic = _normalizeArabicPresentationForms(arabic);

    debugPrint('Translation: "$text" → "$arabic"');

    return {
      'arabic_response': arabic,
      'translation': _transliterate(arabic),
    };
  }

  Future<String> _translateWithLingva(String text, String srcCode) async {
    // Lingva URL: /api/v1/{source}/{target}/{encoded_query}
    final encoded = Uri.encodeComponent(text);
    final uri = Uri.parse('$_lingvaBase/$srcCode/ar/$encoded');

    final response = await http.get(uri).timeout(
      const Duration(seconds: 8),
      onTimeout: () => throw SocketException('Connection timeout'),
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: RequestOptions(path: uri.toString()),
        response: Response(
            requestOptions: RequestOptions(path: uri.toString()),
            statusCode: response.statusCode),
        type: DioExceptionType.badResponse,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final result = json['translation'] as String? ?? '';
    if (result.isEmpty) throw Exception('Lingva returned empty');
    return result.trim();
  }

  Future<String> _translateWithMyMemory(String text, String srcCode) async {
    final uri = Uri.parse('https://api.mymemory.translated.net/get').replace(
      queryParameters: {
        'q': text,
        'langpair': '$srcCode|ar',
        'de': 'app@qalamapp.com',
      },
    );

    final response = await http.get(uri).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw SocketException('Connection timeout'),
    );

    if (response.statusCode != 200) {
      throw DioException(
        requestOptions: RequestOptions(path: uri.toString()),
        response: Response(
            requestOptions: RequestOptions(path: uri.toString()),
            statusCode: response.statusCode),
        type: DioExceptionType.badResponse,
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return (json['responseData']?['translatedText'] as String? ?? '').trim();
  }

  void dispose() {}
}

// ─────────────────────────────────────────────────────────────────────────────
// Convert Arabic Presentation Forms (FE70–FEFC) → standard Unicode Arabic
// This fixes garbled output like "ﻼﻫﺍ" → "لاها"
// ─────────────────────────────────────────────────────────────────────────────
String _normalizeArabicPresentationForms(String text) {
  const Map<int, String> map = {
    0xFE80: 'ء', 0xFE81: 'آ', 0xFE82: 'آ', 0xFE83: 'أ', 0xFE84: 'أ',
    0xFE85: 'ؤ', 0xFE86: 'ؤ', 0xFE87: 'إ', 0xFE88: 'إ',
    0xFE89: 'ئ', 0xFE8A: 'ئ', 0xFE8B: 'ئ', 0xFE8C: 'ئ',
    0xFE8D: 'ا', 0xFE8E: 'ا', 0xFE8F: 'ب', 0xFE90: 'ب',
    0xFE91: 'ب', 0xFE92: 'ب', 0xFE93: 'ة', 0xFE94: 'ة',
    0xFE95: 'ت', 0xFE96: 'ت', 0xFE97: 'ت', 0xFE98: 'ت',
    0xFE99: 'ث', 0xFE9A: 'ث', 0xFE9B: 'ث', 0xFE9C: 'ث',
    0xFE9D: 'ج', 0xFE9E: 'ج', 0xFE9F: 'ج', 0xFEA0: 'ج',
    0xFEA1: 'ح', 0xFEA2: 'ح', 0xFEA3: 'ح', 0xFEA4: 'ح',
    0xFEA5: 'خ', 0xFEA6: 'خ', 0xFEA7: 'خ', 0xFEA8: 'خ',
    0xFEA9: 'د', 0xFEAA: 'د', 0xFEAB: 'ذ', 0xFEAC: 'ذ',
    0xFEAD: 'ر', 0xFEAE: 'ر', 0xFEAF: 'ز', 0xFEB0: 'ز',
    0xFEB1: 'س', 0xFEB2: 'س', 0xFEB3: 'س', 0xFEB4: 'س',
    0xFEB5: 'ش', 0xFEB6: 'ش', 0xFEB7: 'ش', 0xFEB8: 'ش',
    0xFEB9: 'ص', 0xFEBA: 'ص', 0xFEBB: 'ص', 0xFEBC: 'ص',
    0xFEBD: 'ض', 0xFEBE: 'ض', 0xFEBF: 'ض', 0xFEC0: 'ض',
    0xFEC1: 'ط', 0xFEC2: 'ط', 0xFEC3: 'ط', 0xFEC4: 'ط',
    0xFEC5: 'ظ', 0xFEC6: 'ظ', 0xFEC7: 'ظ', 0xFEC8: 'ظ',
    0xFEC9: 'ع', 0xFECA: 'ع', 0xFECB: 'ع', 0xFECC: 'ع',
    0xFECD: 'غ', 0xFECE: 'غ', 0xFECF: 'غ', 0xFED0: 'غ',
    0xFED1: 'ف', 0xFED2: 'ف', 0xFED3: 'ف', 0xFED4: 'ف',
    0xFED5: 'ق', 0xFED6: 'ق', 0xFED7: 'ق', 0xFED8: 'ق',
    0xFED9: 'ك', 0xFEDA: 'ك', 0xFEDB: 'ك', 0xFEDC: 'ك',
    0xFEDD: 'ل', 0xFEDE: 'ل', 0xFEDF: 'ل', 0xFEE0: 'ل',
    0xFEE1: 'م', 0xFEE2: 'م', 0xFEE3: 'م', 0xFEE4: 'م',
    0xFEE5: 'ن', 0xFEE6: 'ن', 0xFEE7: 'ن', 0xFEE8: 'ن',
    0xFEE9: 'ه', 0xFEEA: 'ه', 0xFEEB: 'ه', 0xFEEC: 'ه',
    0xFEED: 'و', 0xFEEE: 'و', 0xFEEF: 'ى', 0xFEF0: 'ى',
    0xFEF1: 'ي', 0xFEF2: 'ي', 0xFEF3: 'ي', 0xFEF4: 'ي',
    0xFEF5: 'لآ', 0xFEF6: 'لآ', 0xFEF7: 'لأ', 0xFEF8: 'لأ',
    0xFEF9: 'لإ', 0xFEFA: 'لإ', 0xFEFB: 'لا', 0xFEFC: 'لا',
  };

  final buffer = StringBuffer();
  for (final codeUnit in text.runes) {
    buffer.write(map[codeUnit] ?? String.fromCharCode(codeUnit));
  }
  return buffer.toString();
}

// ─────────────────────────────────────────────────────────────────────────────
// Arabic → Latin transliteration
// ─────────────────────────────────────────────────────────────────────────────
String _transliterate(String arabic) {
  final cleaned = arabic.replaceAll(
    RegExp(r'[\u064B-\u0652\u0670\u0640]'),
    '',
  );

  const Map<String, String> map = {
    'لا': 'la', 'لأ': 'la', 'لآ': 'laa', 'لإ': 'li',
    'ا': 'a', 'أ': 'a', 'إ': 'i', 'آ': 'aa',
    'ب': 'b', 'ت': 't', 'ث': 'th',
    'ج': 'j', 'ح': 'h', 'خ': 'kh',
    'د': 'd', 'ذ': 'dh', 'ر': 'r', 'ز': 'z',
    'س': 's', 'ش': 'sh', 'ص': 's', 'ض': 'd',
    'ط': 't', 'ظ': 'dh', 'ع': "'", 'غ': 'gh',
    'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l',
    'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w',
    'ي': 'y', 'ى': 'a', 'ة': 'a', 'ء': "'",
    ' ': ' ', '،': ',', '؟': '?', '!': '!', '.': '.',
  };

  final buffer = StringBuffer();
  int i = 0;
  while (i < cleaned.length) {
    if (i + 1 < cleaned.length) {
      final two = cleaned.substring(i, i + 2);
      if (map.containsKey(two)) {
        buffer.write(map[two]);
        i += 2;
        continue;
      }
    }
    buffer.write(map[cleaned[i]] ?? cleaned[i]);
    i++;
  }
  return buffer.toString().trim();
}
