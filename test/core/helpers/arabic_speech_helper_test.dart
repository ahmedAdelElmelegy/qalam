import 'package:flutter_test/flutter_test.dart';
import 'package:arabic/core/helpers/arabic_speech_helper.dart';

void main() {
  group('ArabicSpeechHelper Normlization & Extraction', () {
    test('extractArabic pulls text from quotes', () {
      expect(ArabicSpeechHelper.extractArabic("Say 'أ'"), 'أ');
      expect(ArabicSpeechHelper.extractArabic("Select 'بَ'"), 'بَ');
    });

    test('extractArabic fallback to regex', () {
      expect(ArabicSpeechHelper.extractArabic("Speak أ"), 'أ');
      expect(ArabicSpeechHelper.extractArabic("Pronounce بَ الآن"), 'بَ');
    });

    test('normalizeArabic strips tashkeel and normalizes alif', () {
      expect(ArabicSpeechHelper.normalizeArabic("بَ"), "ب");
      expect(ArabicSpeechHelper.normalizeArabic("ألف"), "الف");
      expect(ArabicSpeechHelper.normalizeArabic("ة"), "ه");
    });
  });

  group('ArabicSpeechHelper Matching Logic', () {
    test('Single letter match with name', () {
      expect(ArabicSpeechHelper.wordsMatch('أ', 'ألف'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('ب', 'باء'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('ب', 'با'), isTrue);
    });

    test('Fatha variations', () {
      expect(ArabicSpeechHelper.wordsMatch('بَ', 'با'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('بَ', 'بأ'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('بَ', 'ب'), isTrue); // Consonant only fallback
    });

    test('Damma variations', () {
      expect(ArabicSpeechHelper.wordsMatch('تُ', 'تو'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('تُ', 'تؤ'), isTrue);
    });

    test('Kasra variations', () {
      expect(ArabicSpeechHelper.wordsMatch('سِ', 'سي'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('سِ', 'سى'), isTrue);
    });

    test('Tanwin variations', () {
      expect(ArabicSpeechHelper.wordsMatch('بً', 'بان'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('بً', 'بن'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('بً', 'با'), isTrue);
    });

    test('Shadda variations', () {
      expect(ArabicSpeechHelper.wordsMatch('بّ', 'بب'), isTrue);
      expect(ArabicSpeechHelper.wordsMatch('بّ', 'ب'), isTrue);
    });

    test('Full phrase matching', () {
      expect(ArabicSpeechHelper.wordsMatch('أنا أرى أسداً', 'انا ارى اسدا'), isTrue);
    });

    test('Similarity threshold for longer strings', () {
      // 70%+ similarity
      expect(ArabicSpeechHelper.wordsMatch('تُفَّاحَةٌ لَذِيذَةٌ', 'تفاحه لذيذه'), isTrue);
    });
  });
}
