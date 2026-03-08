import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';

void main() async {
  final file = File('assets/data/curriculum_data.json');
  final String response = await file.readAsString();
  final data = json.decode(response);

  final List<dynamic> levelsJson = data['levels'];

  for (var l in levelsJson) {
    if (l['title'] is! String) {
      debugPrint('Level ${l['id']} title is ${l['title'].runtimeType}');
    }
    if (l['description'] is! String) {
      debugPrint(
        'Level ${l['id']} description is ${l['description'].runtimeType}',
      );
    }

    final units = l['units'] as List? ?? [];
    for (var u in units) {
      if (u['title'] is! String) {
        debugPrint('Unit ${u['id']} title is ${u['title'].runtimeType}');
      }
      if (u['description'] is! String) {
        debugPrint(
          'Unit ${u['id']} description is ${u['description'].runtimeType}',
        );
      }
      final lessons = u['lessons'] as List? ?? [];
      for (var lesson in lessons) {
        if (lesson['title'] is! String) {
          debugPrint(
            'Lesson ${lesson['id']} title is ${lesson['title'].runtimeType}',
          );
        }
        if (lesson['content'] is! String) {
          debugPrint(
            'Lesson ${lesson['id']} content is ${lesson['content'].runtimeType}',
          );
        }
      }
    }
  }
}
