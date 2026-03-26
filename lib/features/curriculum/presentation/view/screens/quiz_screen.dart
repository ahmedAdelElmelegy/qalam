import 'package:flutter/material.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/quiz/quiz_body.dart';

class QuizScreen extends StatelessWidget {
  final Quiz? quiz;
  final String? lessonId;
  final int? quizLessonId;
  final String levelId;
  final String unitId;
  final bool isSkipQuiz;
  final bool isLevelQuiz;

  const QuizScreen({
    super.key,
    this.quiz,
    this.quizLessonId,
    this.lessonId,
    required this.levelId,
    required this.unitId,
    this.isSkipQuiz = false,
    this.isLevelQuiz = false,
  });

  @override
  Widget build(BuildContext context) {
    return QuizBody(
      quiz: quiz,
      lessonId: lessonId,
      quizLessonId: quizLessonId,
      levelId: levelId,
      unitId: unitId,
      isSkipQuiz: isSkipQuiz,
      isLevelQuiz: isLevelQuiz,
    );
  }
}
