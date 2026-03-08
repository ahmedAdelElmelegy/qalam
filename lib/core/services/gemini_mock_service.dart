// import 'package:arabic_new_app/features/ai_chat/data/models/generated_content_model.dart';
// import 'package:arabic_new_app/features/museum/data/models/museum_place_model.dart';
// import 'package:arabic_new_app/features/museum/data/models/museum_object_model.dart';

// /// Gemini Mock Service
// /// Simulates AI responses for chat functionality
// class GeminiMockService {
//   /// Get AI response for a given query
//   Future<String> getResponse(String query) async {
//     await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
//     final lowerQuery = query.toLowerCase();

//     if (lowerQuery.contains('hello') || lowerQuery.contains('hi') || lowerQuery.contains('مرحبا')) {
//       return 'مرحباً! Hello! I\'m your Arabic learning assistant. How can I help you today?';
//     }

//     if (lowerQuery.contains('how are you') || lowerQuery.contains('كيف حالك')) {
//       return 'أنا بخير، شكراً! (Ana bi-khayr, shukran!) I\'m well, thank you!';
//     }
    
//     // (Existing keyword logic remains same)
//     if (lowerQuery.contains('hello')) return 'Ahlan! How can I help?';
//     return 'I can help you learn Arabic! Try asking for a lesson.';
//   }

//   /// Generate a multimedia lesson based on category
//   Future<GeneratedContentModel> generateMultimediaLesson(String category) async {
//     await Future.delayed(const Duration(seconds: 2));

//     if (category.toLowerCase() == 'grammar') {
//       return const GeneratedContentModel(
//         id: 'gen_grammar_1',
//         title: 'Essential Arabic Pronouns',
//         textAr: 'الضمائر المنفصلة هي الأساس في تكوين الجمل. أنا، أنت، هو، هي.',
//         textEn: 'Personal pronouns are the foundation of sentence structure. I, You, He, She.',
//         imageUrl: 'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?q=80&w=800',
//         audioUrlAr: 'mock_audio_ar_grammar',
//         audioUrlEn: 'mock_audio_en_grammar',
//         category: 'Grammar',
//       );
//     } else if (category.toLowerCase() == 'culture') {
//       return const GeneratedContentModel(
//         id: 'gen_culture_1',
//         title: 'The Art of Arabic Calligraphy',
//         textAr: 'الخط العربي ليس مجرد كتابة، بل هو فن يعبر عن الجمال والروح.',
//         textEn: 'Arabic calligraphy is not just writing; it is an art that expresses beauty and spirit.',
//         imageUrl: 'https://images.unsplash.com/photo-1583089892943-e02e5b017b6a?q=80&w=800',
//         audioUrlAr: 'mock_audio_ar_culture',
//         audioUrlEn: 'mock_audio_en_culture',
//         category: 'Culture',
//       );
//     }

//     return const GeneratedContentModel(
//       id: 'gen_generic_1',
//       title: 'Daily Vocabulary',
//       textAr: 'كل يوم هو فرصة جديدة لتعلم كلمات جديدة.',
//       textEn: 'Every day is a new opportunity to learn new words.',
//       imageUrl: 'https://images.unsplash.com/photo-1456513080510-7bf3a84b82f8?q=80&w=800',
//       audioUrlAr: 'mock_audio_ar_gen',
//       audioUrlEn: 'mock_audio_en_gen',
//       category: 'General',
//     );
//   }

//   /// Generate dynamic museum places
//   /// Generate dynamic museum places with smart content and reliable images
//   Future<List<MuseumPlaceModel>> generateMuseumPlaces({
//     String? prompt,
//     int count = 3,
//     bool isInitialLoad = false,
//   }) async {
//     await Future.delayed(const Duration(seconds: 2));

//     final List<Map<String, String>> _topics = [
//       {
//         'name': 'Lost City of Petra',
//         'desc': 'Explore the Rose City carved into pink sandstone cliffs.',
//         'icon': 'terrain', 
//         'img': 'https://images.unsplash.com/photo-1579606038817-2292025a3a46?q=80&w=600'
//       },
//       {
//         'name': 'Pyramids of Giza',
//         'desc': 'Stand before the ancient wonders of Egypt.',
//         'icon': 'change_history',
//         'img': 'https://images.unsplash.com/photo-1503177119275-0aa32b3a9368?q=80&w=600'
//       },
//       {
//         'name': 'Alhambra Palace',
//         'desc': 'Witness the exquisite Islamic architecture of Andalusia.',
//         'icon': 'architecture',
//         'img': 'https://images.unsplash.com/photo-1548246473-5faed99071c6?q=80&w=600'
//       },
//       {
//         'name': 'Islamic Art Museum',
//         'desc': 'A collection of calligraphy, ceramics, and textiles.',
//         'icon': 'brush',
//         'img': 'https://images.unsplash.com/photo-1565058087963-394bf3290680?q=80&w=600'
//       },
//       {
//         'name': 'Ancient Carthage',
//         'desc': 'Walk through the ruins of the great Phoenician city.',
//         'icon': 'foundation',
//         'img': 'https://images.unsplash.com/photo-1563245372-f2172081498b?q=80&w=600'
//       },
//       {
//         'name': 'Sheikh Zayed Mosque',
//         'desc': 'A modern masterpiece of Islamic architecture.',
//         'icon': 'mosque',
//         'img': 'https://images.unsplash.com/photo-1512453979798-5ea904ac2294?q=80&w=600'
//       },
//       {
//         'name': 'Old City of Damascus',
//         'desc': 'One of the oldest continuously inhabited cities.',
//         'icon': 'location_city',
//         'img': 'https://images.unsplash.com/photo-1554163459-71578332155f?q=80&w=600'
//       },
//       {
//         'name': 'Blue City of Chefchaouen',
//         'desc': 'Wander the blue-washed streets of Morocco.',
//         'icon': 'palette',
//         'img': 'https://images.unsplash.com/photo-1534008897995-27a23e859048?q=80&w=600'
//       },
//     ];

//     final now = DateTime.now().millisecondsSinceEpoch;
//     final List<MuseumPlaceModel> newPlaces = [];
    
//     // Determine start index based on randomness for variety in "infinite" scroll
//     int startIndex = (now % _topics.length);

//     for (int i = 0; i < count; i++) {
//         final topicIndex = (startIndex + i) % _topics.length;
//         final topic = _topics[topicIndex];
        
//         newPlaces.add(MuseumPlaceModel(
//           id: 'ai_${now}_$i',
//           name: topic['name']!,
//           description: topic['desc']!,
//           iconName: topic['icon']!,
//           imageUrl: topic['img']!,
//           objects: [],
//         ));
//     }

//     return newPlaces;
//   }

//   /// Generate 5x5 vocabulary for a specific place
//   Future<List<MuseumObjectModel>> generateVocabularyForPlace(String placeId) async {
//     await Future.delayed(const Duration(seconds: 2));

//     // Simulated 5x5 vocabulary (showing first 5 here)
//     return [
//       const MuseumObjectModel(
//         id: 'v1',
//         icon: 'menu_book',
//         localizedNames: {
//           'ar': 'مكتبة',
//           'en': 'Library',
//           'fr': 'Bibliothèque',
//           'de': 'Bibliothek',
//           'zh': '图书馆',
//           'ru': 'Библиотека',
//         },
//         arabicName: 'مكتبة', // Legacy
//         englishTranslation: 'Library', // Legacy
//         pronunciation: 'maktaba',
//         arabicSentence: 'أذهب إلى المكتبة للدراسة',
//         englishSentence: 'I go to the library to study',
//         imageUrl: 'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=200',
//         positionX: 0.1,
//         positionY: 0.2,
//       ),
//       const MuseumObjectModel(
//         id: 'v2',
//         icon: 'book',
//         localizedNames: {
//           'ar': 'كتاب',
//           'en': 'Book',
//           'fr': 'Livre',
//           'de': 'Buch',
//           'zh': '书',
//           'ru': 'Книга',
//         },
//         arabicName: 'كتاب',
//         englishTranslation: 'Book',
//         pronunciation: 'kitāb',
//         arabicSentence: 'أقرأ الكتاب كل يوم',
//         englishSentence: 'I read the book every day',
//         imageUrl: 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?q=80&w=200',
//         positionX: 0.3,
//         positionY: 0.4,
//       ),
//     ];
//   }
// }
