
class ArabicSpeechHelper {
  // Map of letter → list of accepted spoken forms (the letter name as Arabs say it)
  static const Map<String, List<String>> _letterNames = {
    'أ': ['الف', 'آلف', 'ألف', 'اليف'],
    'ا': ['الف', 'آلف', 'ألف'],
    'ب': ['باء', 'با', 'بي'],
    'ت': ['تاء', 'تا', 'تي'],
    'ث': ['ثاء', 'ثا', 'ساء', 'صاء', 'شا'],
    'ج': ['جيم', 'جم', 'جيم'],
    'ح': ['حاء', 'حا', 'ها'],
    'خ': ['خاء', 'خا'],
    'د': ['دال', 'ديل'],
    'ذ': ['ذال', 'زال', 'ظال'],
    'ر': ['راء', 'را'],
    'ز': ['زاي', 'زاء', 'زا', 'زين'],
    'س': ['سين', 'سن'],
    'ش': ['شين', 'شن'],
    'ص': ['صاد', 'صد'],
    'ض': ['ضاد', 'داد', 'ظاد'],
    'ط': ['طاء', 'طا', 'تاء'],
    'ظ': ['ظاء', 'ظا', 'ذاء', 'زاء'],
    'ع': ['عين', 'عن'],
    'غ': ['غين', 'غن'],
    'ف': ['فاء', 'فا'],
    'ق': ['قاف', 'كاف', 'غاف'],
    'ك': ['كاف', 'قاف'],
    'ل': ['لام', 'لم'],
    'م': ['ميم', 'مم'],
    'ن': ['نون', 'نن'],
    'ه': ['هاء', 'ها'],
    'هـ': ['هاء', 'ها'],
    'و': ['واو', 'وو'],
    'ي': ['ياء', 'يا'],
    'لا': ['لا', 'لاء'],
  };

  /// Normalizes Arabic text for pronunciation comparison (strips non-essential chars)
  static String normalizeArabic(String text) {
    return text
        .replaceAll(RegExp(r'[\u064B-\u065F]'), '') // Remove tashkeel
        .replaceAll('ٱ', 'ا') // Normalize alef wasla
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه') // Normalize ta marbuta
        .replaceAll('ى', 'ي') // Normalize ya
        .replaceAll('ـ', '') // Remove Tatweel (Kashida)
        .replaceAll(
          RegExp(r'[^\u0621-\u064A\u0660-\u06690-9\s]'),
          '',
        ) // Keep Arabic letters, numbers, and spaces
        .trim()
        .toLowerCase();
  }

  /// Extracts Arabic text from a string, often used to strip "Say '...'" instructions.
  static String extractArabic(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return '';

    // Look for content between single quotes first (e.g., Select 'أ')
    final quoteMatch = RegExp(r"'(.*?)'").firstMatch(trimmed);
    if (quoteMatch != null) return quoteMatch.group(1)!.trim();

    // Check if the whole text is mostly Arabic — if so, return as-is
    final arabicCharCount = RegExp(r'[\u0600-\u06FF]').allMatches(trimmed).length;
    final totalChars = trimmed.replaceAll(' ', '').length;
    if (totalChars > 0 && arabicCharCount / totalChars > 0.5) {
      return trimmed;
    }

    // Otherwise extract and JOIN all Arabic segments (spaces kept between chunks)
    final arabicRegex = RegExp(
      r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF\s،؟!.]+',
    );
    final matches = arabicRegex.allMatches(trimmed);
    if (matches.isNotEmpty) {
      return matches.map((m) => m.group(0)!).join(' ').trim();
    }

    return trimmed;
  }

  /// Deep comparison between expected Arabic string and actual STT input
  static bool wordsMatch(String expected, String actual) {
    if (expected.trim().isEmpty || actual.trim().isEmpty) return false;

    final String eTrim = expected.trim();
    final String aWord = actual.trim();

    // 1. Tashkeel-aware matching for single characters
    if (eTrim.length <= 2) {
      // Correct Arabic harakat Unicode range: U+064B – U+0652
      final harakatChars = RegExp(r'[\u064B-\u0652]');

      final bool hasHaraka = eTrim.length == 2 && harakatChars.hasMatch(eTrim[1]);

      if (hasHaraka) {
        final String baseLetter = eTrim[0];
        final String haraka = eTrim[1];

        // 1a. Core phonetic check via STT variations
        final List<String> sttForms = _getSttVariationsForHaraka(baseLetter, haraka);
        
        // Check normalized aWord against each variation
        final String aWordNorm = normalizeArabic(aWord);
        for (final form in sttForms) {
          final String formNorm = normalizeArabic(form);
          if (aWordNorm == formNorm || aWord == form) return true;
        }

        // 1b. NO FALLBACK to letter name if haraka is present!
        // This ensures "Ba" is not accepted when "Bu" is expected.
        return false;
      }

      // Standard single-letter matching (no tashkeel in answer)
      if (normalizeArabic(eTrim) == normalizeArabic(aWord)) return true;
      
      final acceptedNames = _letterNames[eTrim] ?? [];
      if (acceptedNames.contains(aWord)) return true;
      for (final name in acceptedNames) {
        if (aWord.contains(name)) return true;
      }

      return false;
    }

    // 2. Full word/sentence matching
    if (eTrim == aWord) return true;
    if (normalizeArabic(eTrim) == normalizeArabic(aWord)) return true;

    // 3. Number matching
    if (_matchNumbers(eTrim, aWord)) return true;

    // 4. Similarity Threshold (for longer phrases)
    if (eTrim.length > 3) {
      return _calculateSimilarity(eTrim, aWord) > 0.7;
    }

    return false;
  }

  /// Returns the expected spoken forms a user might say for a letter + haraka combination.
  /// Based on the official Arabic diacritics phonetic reference:
  ///   Fatha  (U+064E) = short 'a'
  ///   Kasra  (U+0650) = short 'i'
  ///   Damma  (U+064F) = short 'u'
  ///   Shadda (U+0651) = doubled consonant
  ///   Sukun  (U+0652) = no vowel
  ///   Tanween Fath (U+064B) = '-an' suffix
  ///   Tanween Damm (U+064C) = '-un' suffix
  ///   Tanween Kasr (U+064D) = '-in' suffix
  static List<String> _getSttVariationsForHaraka(String baseLetter, String haraka) {
    List<String> variations = [];
    switch (haraka) {
      case '\u064E': // Fatha → short 'a'
        // STT usually encodes as letter + long-a (ا/ى)
        variations = [
          '$baseLetter\u0627', // ba  → با
          '$baseLetter\u0649', // ba  → بى
          '$baseLetter\u0623', // ba  → بأ
          '$baseLetter\u0647', // bah → به (some dialects drop 'a' as 'ah')
        ];
        break;

      case '\u064F': // Damma → short 'u'
        // STT usually encodes as letter + waw (و)
        variations = [
          '$baseLetter\u0648', // bu  → بو
          '$baseLetter\u0624', // bu  → بؤ
          '$baseLetter\u0648\u0627', // bwa → بوا
        ];
        break;

      case '\u0650': // Kasra → short 'i'
        // STT usually encodes as letter + ya (ي)
        variations = [
          '$baseLetter\u064A', // bi  → بي
          '$baseLetter\u0649', // bi  → بى
          '$baseLetter\u0626', // bi  → بئ
          '$baseLetter\u064A\u0627', // bia → بيا
        ];
        break;

      case '\u0651': // Shadda → doubled consonant
        return [
          baseLetter + baseLetter, // bb
          baseLetter, // b (sometimes only one heard)
          '$baseLetter\u0651', // with shadda mark itself
          ...(_letterNames[baseLetter] ?? []),
        ];

      case '\u0652': // Sukun → no vowel
        return [baseLetter, ...(_letterNames[baseLetter] ?? [])];

      case '\u064B': // Tanween Fath → '-an'
        variations = [
          '$baseLetter\u0646', // bn
          '$baseLetter\u0627\u0646', // ban  → بان
          '$baseLetter\u0627', // ba   → با (dropped n)
          '\u0627\u0646', // an   (base dropped)
        ];
        break;

      case '\u064C': // Tanween Damm → '-un'
        variations = [
          '$baseLetter\u0646', // bn
          '$baseLetter\u0648\u0646', // bun  → بون
          '$baseLetter\u0648', // bu   → بو (dropped n)
          '\u0648\u0646', // un
        ];
        break;

      case '\u064D': // Tanween Kasr → '-in'
        variations = [
          '$baseLetter\u0646', // bn
          '$baseLetter\u064A\u0646', // bin  → بين
          '$baseLetter\u064A', // bi   → بي (dropped n)
          '\u064A\u0646', // in
        ];
        break;

      default:
        return [baseLetter];
    }

    // Add base letter as a fallback for all harakat if not already present
    // This handles cases where STT only detects the base consonant (common for short vowels/Alif)
    if (!variations.contains(baseLetter)) {
      variations.add(baseLetter);
    }

    return variations;
  }

  static bool _matchNumbers(String expected, String actual) {
    const numberMap = {
      '0': ['صفر', '٠'],
      '1': ['واحد', 'واحده', '١', 'احد', 'إحدى', 'احده'],
      '2': ['اثنان', 'اثنين', '٢', 'زوج', 'اثنتان', 'اثنتين'],
      '3': ['ثلاثه', 'ثلاث', '٣', 'تلاته'],
      '4': ['اربعه', 'اربع', '٤'],
      '5': ['خمسه', 'خمس', '٥'],
      '6': ['سته', 'ست', '٦'],
      '7': ['سبعه', 'سبع', '٧'],
      '8': ['ثمانيه', 'ثماني', '٨', 'تمانيه'],
      '9': ['تسعه', 'تسع', '٩'],
      '10': ['عشره', 'عشر', '١٠'],
    };

    for (var entry in numberMap.entries) {
      final group = [entry.key, ...entry.value];
      if (group.contains(expected) && group.contains(actual)) {
        return true;
      }
    }
    return false;
  }

  static double _calculateSimilarity(String s1, String s2) {
    final String s1Norm = normalizeArabic(s1);
    final String s2Norm = normalizeArabic(s2);
    
    if (s1Norm == s2Norm) return 1.0;
    
    int matches = 0;
    int maxLen = s1Norm.length > s2Norm.length ? s1Norm.length : s2Norm.length;
    
    for (int i = 0; i < s1Norm.length && i < s2Norm.length; i++) {
      if (s1Norm[i] == s2Norm[i]) matches++;
    }
    
    return maxLen > 0 ? (matches / maxLen) : 0.0;
  }
}
