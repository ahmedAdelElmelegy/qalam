import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppURL {
  static String get baseUrl => dotenv.get('BASEURL');
  static const String signIn = 'Auth/login';
  static const String signUp = 'Auth/register';
  static const String language = 'Languages';
  static const String history = 'Museum/CultureIsland/History';
  static const String cities = 'Museum/CultureIsland/City';
  static const String tradition = 'Museum/CultureIsland/Tradition';
  static const String clothing = 'Museum/CultureIsland/Clothing';
  static const String food = 'Museum/CultureIsland/Food';
  static const String addvirtualGallaryPlace = 'Museum/PLace';
  static const String addvirtualGallarySentance = 'Sentence';
  static const String getvirtualGallaryPlace = 'Museum/PLace';

  static const String getvirtualGallarySentance = 'Sentence';
  static const String getUserProfile = 'Users';
  // image url
  static String get imagePath => dotenv.get('IMAGE_PATH');
  // for lessons
  static const String getLevels = 'Curriculum/Level';
  static const String getUnits = 'Curriculum/Unit';
  static const String getLessons = 'Curriculum/Lesson';
  static const String getQuiz = 'Curriculum/Quiz/by-lesson';
  static const String syncQuiz = 'Progress/sync';
  static const String getProgress = "Progress/stats";
}
