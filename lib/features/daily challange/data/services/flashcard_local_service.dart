import 'dart:convert';
import 'package:arabic/features/daily%20challange/data/models/question_model.dart';
import 'package:flutter/services.dart';

class FlashcardLocalService {
  Future<List<QuestionModel>> getFlashcards({
    required int day,
    required String locale,
  }) async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/speaking_challenges.json',
      );
      final data = await json.decode(response);
      final List<dynamic> challenges = data['challenges'] ?? [];

      final dayData = challenges.firstWhere(
        (element) => element['day'] == day,
        orElse: () => null,
      );

      if (dayData == null) {
        throw Exception('Day $day not found in data.');
      }

      final List<dynamic> questionsList = dayData['questions'] ?? [];

      // Take up to 10 items (or exactly 10 if data exists)
      final List<dynamic> targetList = questionsList.length > 10
          ? questionsList.sublist(0, 10)
          : questionsList;

      return targetList.map((item) {
        return QuestionModel.fromJson(
          item as Map<String, dynamic>,
          locale: locale,
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to load local flashcards: $e');
    }
  }
}
