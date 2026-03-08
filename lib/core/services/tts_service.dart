import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:arabic/core/utils/arabic_text_utils.dart';
import 'package:arabic/core/utils/local_storage.dart';

class TtsService {
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;
  Completer<void>? _initCompleter;

  // Cache the configured Arabic language tag so speak() doesn't re-check every call
  String? _cachedArabicLang;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (_initCompleter != null) return _initCompleter!.future;

    _initCompleter = Completer<void>();

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        await _flutterTts.setEngine("com.google.android.tts");
      }

      final savedSpeed = await LocalStorage.getTtsSpeed();

      await _flutterTts.setVolume(1.0);
      await _flutterTts.setSpeechRate(savedSpeed);
      // Slightly lower pitch sounds more natural for Arabic
      await _flutterTts.setPitch(0.95);
      await _flutterTts.setSharedInstance(true);

      // Pre-configure Arabic once so speak() is instant
      await _configureArabic();

      _isInitialized = true;
      _initCompleter!.complete();
    } catch (e) {
      debugPrint('Error initializing TTS: $e');
      _initCompleter!.completeError(e);
      _initCompleter = null;
    }
  }

  /// Configure Arabic language + best voice once. Cached for later reuse.
  Future<void> _configureArabic() async {
    const candidates = ['ar-SA', 'ar-EG', 'ar'];
    for (final lang in candidates) {
      final available = await _flutterTts.isLanguageAvailable(lang);
      if (available == true) {
        await _flutterTts.setLanguage(lang);
        _cachedArabicLang = lang;
        await _setBestVoice(lang);
        debugPrint('TTS: Arabic configured with $lang');
        return;
      }
    }
    debugPrint('TTS: No Arabic language found on device');
  }

  Future<void> updateSpeed(double speed) async {
    await initialize();
    await _flutterTts.setSpeechRate(speed);
    await LocalStorage.saveTtsSpeed(speed);
  }

  /// Pre-warms the TTS engine so the first real speak() call is instant.
  /// Speaks a zero-width space at volume 0 — inaudible to the user.
  Future<void> warmUp() async {
    await initialize();
    try {
      await _flutterTts.getMaxSpeechInputLength;
      await _flutterTts.setVolume(0);
      await _flutterTts.speak('\u200B'); // zero-width space — loads the engine
      await Future.delayed(const Duration(milliseconds: 600));
      await _flutterTts.stop();
      await _flutterTts.setVolume(1.0);
      debugPrint('TTS: warm-up complete');
    } catch (e) {
      // Non-fatal — just log and continue
      debugPrint('TTS warm-up error: $e');
      await _flutterTts.setVolume(1.0);
    }
  }

  Future<void> _setBestVoice(String languageCode) async {
    try {
      final List<dynamic> voices = await _flutterTts.getVoices;
      final baseLang = languageCode.toLowerCase().split('-')[0];

      Map<dynamic, dynamic>? naturalVoice;
      Map<dynamic, dynamic>? googleVoice;
      Map<dynamic, dynamic>? anyVoice;

      for (final voice in voices) {
        if (voice is! Map) continue;
        final name = voice['name']?.toString().toLowerCase() ?? '';
        final locale = voice['locale']?.toString().toLowerCase() ?? '';

        if (!locale.contains(baseLang)) continue;

        if (name.contains('natural') || name.contains('enhanced')) {
          naturalVoice = voice;
          break; // Best possible — stop immediately
        }
        if (googleVoice == null &&
            (name.contains('google') || name.contains('network'))) {
          googleVoice = voice;
        }
        anyVoice ??= voice;
      }

      final selected = naturalVoice ?? googleVoice ?? anyVoice;
      if (selected != null) {
        debugPrint('TTS: voice = ${selected['name']} / ${selected['locale']}');
        await _flutterTts.setVoice({
          "name": selected["name"],
          "locale": selected["locale"],
        });
      }
    } catch (e) {
      debugPrint('Error setting best voice: $e');
    }
  }

  Future<void> speak(String text, {String language = 'en-US'}) async {
    await initialize();
    try {
      String processedText = text.trim();
      if (processedText.isEmpty) return;

      if (language.startsWith('ar')) {
        // Pre-process text for better Arabic pronunciation
        processedText = ArabicTextUtils.prepareForTts(processedText);

        // Use cached lang if available to skip the isLanguageAvailable round-trip
        if (_cachedArabicLang != null) {
          await _flutterTts.setLanguage(_cachedArabicLang!);
          await _flutterTts.speak(processedText);
          return;
        }

        // Fallback: configure now (first time after a reset)
        await _configureArabic();
        await _flutterTts.speak(processedText);
      } else {
        final isAvailable = await _flutterTts.isLanguageAvailable(language);
        if (isAvailable == true) {
          await _flutterTts.setLanguage(language);
          await _setBestVoice(language);
        }
        await _flutterTts.speak(processedText);
      }
    } catch (e) {
      debugPrint('Error speaking: $e');
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('Error stopping TTS: $e');
    }
  }

  Future<void> setStartHandler(VoidCallback onStart) async {
    await initialize();
    _flutterTts.setStartHandler(onStart);
  }

  Future<void> setCompletionHandler(VoidCallback onComplete) async {
    await initialize();
    _flutterTts.setCompletionHandler(onComplete);
  }

  Future<void> setErrorHandler(Function(String) onError) async {
    await initialize();
    _flutterTts.setErrorHandler((message) => onError(message));
  }

  /// Stops playback and clears handlers to prevent leaks after screen disposal.
  void clearHandlers() {
    _flutterTts.setStartHandler(() {});
    _flutterTts.setCompletionHandler(() {});
    _flutterTts.setErrorHandler((_) {});
    _flutterTts.stop();
  }

  void dispose() => clearHandlers();

  String getTtsLanguage(String code) {
    switch (code) {
      case 'fr':
        return 'fr-FR';
      case 'de':
        return 'de-DE';
      case 'zh':
        return 'zh-CN';
      case 'ru':
        return 'ru-RU';
      case 'ar':
        return 'ar-SA';
      case 'en':
      default:
        return 'en-US';
    }
  }
}
