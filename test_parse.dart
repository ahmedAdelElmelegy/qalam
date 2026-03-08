import 'dart:convert';
import 'dart:io';

void main() async {
  final file = File('assets/data/curriculum_data.json');
  final String response = await file.readAsString();
  final data = json.decode(response);

  final List<dynamic> levelsJson = data['levels'];

  for (var i = 0; i < levelsJson.length; i++) {
    try {
      final level = levelsJson[i];
      level['id'] as String;
      level['title'] as String;
      level['description'] as String;

      final units = level['units'] as List? ?? [];
      for (var j = 0; j < units.length; j++) {
        final unit = units[j];
        unit['id'] as String;
        unit['title'] as String;
        unit['description'] as String;

        final lessons = unit['lessons'] as List? ?? [];
        for (var k = 0; k < lessons.length; k++) {
          final lesson = lessons[k];
          try {
            lesson['id'] as String;
            lesson['title'] as String;
            lesson['content'] as String;

            // Check vocabulary
            final vocab = lesson['vocabulary'] as List? ?? [];
            for (var v in vocab) {
              v['arabic'] as String;
              v['translation'] as String;
            }

            // Check questions in quiz
            final quiz = lesson['quiz'];
            if (quiz != null) {
              final questions = quiz['questions'] as List? ?? [];
              for (var q in questions) {
                try {
                  q['id'] as String;
                  q['text'] as String;
                  q['correctAnswer'] as String;
                  q['audioUrl'] as String?;
                  q['imageUrl'] as String?;
                } catch (e) {
                  return;
                }
              }
            }
          } catch (e) {
            return;
          }
        }

        // unitQuiz
        final unitQuiz = unit['unitQuiz'];
        if (unitQuiz != null) {
          final questions = unitQuiz['questions'] as List? ?? [];
          for (var q in questions) {
            try {
              q['id'] as String;
              q['text'] as String;
              q['correctAnswer'] as String;
            } catch (e) {
              return;
            }
          }
        }
      }

      // levelQuiz
      final levelQuiz = level['levelQuiz'];
      if (levelQuiz != null) {
        final questions = levelQuiz['questions'] as List? ?? [];
        for (var q in questions) {
          try {
            q['id'] as String;
            q['text'] as String;
            q['correctAnswer'] as String;
          } catch (e) {
            return;
          }
        }
      }
    } catch (e) {
      return;
    }
  }
}
