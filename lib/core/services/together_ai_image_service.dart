import 'dart:async';
import 'dart:convert';
import 'package:arabic/core/services/cloudinary_service.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Image service — Together AI is temporarily disabled for testing.
/// Returns a rotating set of fixed Cloudinary URLs instead of calling the API.
///
/// To re-enable Together AI + Cloudinary upload, set [_useRealGeneration] = true.
class TogetherAiImageService {
  // ── Testing flag ──────────────────────────────────────────────────────────
  /// Set to [true] to re-enable actual Together AI image generation.
  static const bool _useRealGeneration = true;

  /// Placeholder Cloudinary URLs used when [_useRealGeneration] is false.
  static const List<String> _placeholders = [
    'https://res.cloudinary.com/djr9wbmet/image/upload/v1771535454/gallery_ai/mpz9mtivxow6tkr8gju2.jpg',
    'https://res.cloudinary.com/djr9wbmet/image/upload/v1771535458/gallery_ai/wjbnhyefkkr9l7bzryvc.jpg',
    'https://res.cloudinary.com/djr9wbmet/image/upload/v1771535461/gallery_ai/q5fsustlra9kzumifz79.jpg',
  ];

  int _placeholderIndex = 0;

  // ── Together AI config (used when _useRealGeneration = true) ─────────────
  static final String _apiKey = dotenv.env['TOGETHER_AI_API_KEY'] ?? '';
  static const String _baseUrl =
      'https://api.together.xyz/v1/images/generations';
  static const String _model = 'black-forest-labs/FLUX.1-schnell';

  final CloudinaryService _cloudinaryService;

  // Rate limiting infrastructure
  final _queue = <_RequestItem>[];
  bool _isProcessing = false;

  TogetherAiImageService({CloudinaryService? cloudinaryService})
    : _cloudinaryService = cloudinaryService ?? CloudinaryService();

  /// Returns the next URL — either a real generated + Cloudinary URL,
  /// or the next placeholder from the fixed list (when in test mode).
  Future<String> generateImage(String prompt) {
    if (!_useRealGeneration) {
      // Cycle through the 3 placeholder URLs
      final url = _placeholders[_placeholderIndex % _placeholders.length];
      _placeholderIndex++;
      debugPrint('🖼️  [TEST MODE] Placeholder image: $url');
      return Future.value(url);
    }

    final completer = Completer<String>();
    _queue.add(_RequestItem(prompt, completer));
    _processQueue();
    return completer.future;
  }

  Future<void> _processQueue() async {
    if (_isProcessing) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final item = _queue.removeAt(0);
      try {
        final result = await _performRequest(item.prompt);
        item.completer.complete(result);
      } catch (e) {
        item.completer.complete(_placeholders[0]);
      }
      // Sustain max 2 requests per second
      await Future.delayed(const Duration(milliseconds: 600));
    }
    _isProcessing = false;
  }

  Future<String> _performRequest(String prompt) async {
    String tempUrl = _placeholders[0];
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'prompt': prompt,
          'disable_safety_checker': false,
          'n': 1,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['data'] != null &&
            data['data'] is List &&
            data['data'].isNotEmpty) {
          tempUrl = data['data'][0]['url'] ?? tempUrl;
        }
      } else {
        debugPrint(
          'Together AI Error: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Exception generating image: $e');
    }

    // Upload to Cloudinary and return permanent URL
    return _cloudinaryService.uploadFromUrl(tempUrl);
  }
}

class _RequestItem {
  final String prompt;
  final Completer<String> completer;
  _RequestItem(this.prompt, this.completer);
}
