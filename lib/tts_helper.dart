import 'package:flutter_tts/flutter_tts.dart';

class TtsHelper {
  final FlutterTts _flutterTts = FlutterTts();

  // Settings
  final double _volume = 1.0;
  double _pitch = 1.0;
  double _rate = 0.5;
  String _language = 'ar-SA';

  TtsHelper() {
    _initTts();
  }

  Future<void> _initTts() async {
    // On Android, we prefer Google's engine for best compatibility
    var engines = await _flutterTts.getEngines;
    if (engines.contains('com.google.android.tts')) {
      await _flutterTts.setEngine('com.google.android.tts');
    }

    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setSpeechRate(_rate);
    
    await setLanguage(_language);

    // Ensure the engine is ready
    await _flutterTts.awaitSpeakCompletion(true);

    _flutterTts.setErrorHandler((msg) {
      // Internal error tracking can go here if needed
    });
  }

  Future<void> speak(String text) async {
    if (text.isNotEmpty) {
      await _flutterTts.speak(text);
    }
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }

  // Setters for rate and pitch
  Future<void> setRate(double rate) async {
    _rate = rate;
    await _flutterTts.setSpeechRate(_rate);
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    await _flutterTts.setPitch(_pitch);
  }

  Future<void> setLanguage(String lang) async {
    _language = lang;
    
    // Check if the specific language is available
    bool isAvailable = await _flutterTts.isLanguageAvailable(_language);
    
    if (!isAvailable) {
      // Fallback strategies for common language tags
      if (_language.contains('-')) {
        String baseLang = _language.split('-')[0];
        if (await _flutterTts.isLanguageAvailable(baseLang)) {
          _language = baseLang;
        }
      }
    }
    
    await _flutterTts.setLanguage(_language);
  }

  double get rate => _rate;
  double get pitch => _pitch;
  String get language => _language;
}
