import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/data/curriculum_data.json');
  final jsonStr = file.readAsStringSync();
  final data = json.decode(jsonStr);

  for (var level in data['levels']) {
    if (level['id'] == 'a0') {
      for (var unit in level['units']) {
        for (var lesson in unit['lessons']) {
          if (lesson['quiz'] != null) {
            for (var q in lesson['quiz']['questions']) {
              final text = q['text'].toString();
              final ans = q['correctAnswer'].toString();
              if (text.contains('ت') ||
                  ans.contains('ت') ||
                  text.contains('ط') ||
                  ans.contains('ط')) {
                // print('Lesson: ${lesson['id']}, Q: ${q['id']}, text: $text, type: ${q['type']}, ans: $ans');
              }
            }
          }
        }
      }
    }
  }
}
