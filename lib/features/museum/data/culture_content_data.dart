import 'dart:ui';
import 'models/culture_content_model.dart';

const List<CultureContent> cultureContents = [
  CultureContent(
    id: 'history',
    title: 'History of Arabic',
    description: 'Explore the rich origins and evolution of the Arabic language.',
    imageUrl: 'assets/images/history_bg.png', // Placeholder
    baseColor: Color(0xFFD4AF37),
    sections: [
      CultureSection(
        title: 'Origins',
        content: 'Arabic belongs to the Semitic family of languages. Its history goes back to the Iron Age.',
        bulletPoints: [
          'Originated in the Arabian Peninsula',
          'Related to Hebrew and Aramaic',
          'Earliest inscriptions date back to 8th century BC'
        ],
      ),
      CultureSection(
        title: 'The Golden Age',
        content: 'During the Islamic Golden Age, Arabic became a major language of science, mathematics, and philosophy.',
        bulletPoints: [
          'Language of the Quran',
          'Preserved Greek and Roman knowledge',
          'Influenced Spanish, Portuguese, and Sicilian'
        ],
      ),
      CultureSection(
        title: 'Modern Standard Arabic',
        content: 'Today, Modern Standard Arabic (MSA) is the formal language used in media, literature, and education across the Arab world.',
      ),
    ],
  ),
  CultureContent(
    id: 'grammar',
    title: 'Arabic Grammar',
    description: 'Master the structure and rules of Arabic sentences.',
    imageUrl: 'assets/images/grammar_bg.png', // Placeholder
    baseColor: Color(0xFF6366F1),
    sections: [
      CultureSection(
        title: 'Root System',
        content: 'Most Arabic words are derived from a three-letter root (Triliteral Root) which conveys a core meaning.',
        bulletPoints: [
          'K-T-B (Writing)',
          'D-R-S (Studying)',
          'S-L-M (Peace/Submission)'
        ],
      ),
      CultureSection(
        title: 'Gender and Number',
        content: 'Arabic nouns are either masculine or feminine and can be singular, dual, or plural.',
        bulletPoints: [
          'Dual form (Muthanna) is unique',
          'Plural forms detailed variations',
          'Agreement between adjectives and nouns'
        ],
      ),
    ],
  ),
  CultureContent(
    id: 'vocabulary',
    title: 'Essential Vocabulary',
    description: 'Build your core vocabulary with essential words and phrases.',
    imageUrl: 'assets/images/vocabulary_bg.png', // Placeholder
    baseColor: Color(0xFF10B981),
    sections: [
      CultureSection(
        title: 'Common Greetings',
        content: 'Learn how to greet people in various situations.',
        bulletPoints: [
          'As-salamu alaykum (Peace be upon you)',
          'Marhaban (Hello)',
          'Sabah al-khair (Good morning)'
        ],
      ),
      CultureSection(
        title: 'Numbers',
        content: 'Counting from 1 to 10 is fundamental.',
        bulletPoints: [
          'Wahid (1)',
          'Ithnan (2)',
          'Thalatha (3)'
        ],
      ),
    ],
  ),
   CultureContent(
    id: 'lessons',
    title: 'Structured Lessons',
    description: 'Follow a step-by-step path to fluency.',
    imageUrl: 'assets/images/lessons_bg.png', // Placeholder
    baseColor: Color(0xFFEC4899),
    sections: [
      CultureSection(
        title: 'Beginner Level',
        content: 'Start with the alphabet and basic sounds.',
        bulletPoints: [
          'Al-Alphabet (Abjad)',
          'Short Vowels (Harakat)',
          'Connecting Letters'
        ],
      ),
    ],
  ),
  CultureContent(
    id: 'culture',
    title: 'Arab Culture',
    description: 'Immerse yourself in the traditions and customs.',
    imageUrl: 'assets/images/culture_bg.png', // Placeholder
    baseColor: Color(0xFF8B5CF6),
    sections: [
      CultureSection(
        title: 'Hospitality',
        content: 'Hospitality is a core value in Arab culture.',
        bulletPoints: [
          'Serving coffee (Gahwa)',
          'Honoring guests',
          'Generosity'
        ],
      ),
       CultureSection(
        title: 'Calligraphy',
        content: 'Arabic calligraphy is a revered art form.',
        bulletPoints: [
          'Kufic script',
          'Naskh script',
          'Thuluth script'
        ],
      ),
    ],
  ),
];
