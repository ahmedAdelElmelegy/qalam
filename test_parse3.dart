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
      debugPrint(
        'Level ${l['id']} has a title of type ${l['title'].runtimeType}: ${l['title']}',
      );
    }
    final units = l['units'] as List? ?? [];
    for (var u in units) {
      if (u['title'] is! String) {
        debugPrint(
          'Unit ${u['id']} has a title of type ${u['title'].runtimeType}: ${u['title']}',
        );
      }
      final lessons = u['lessons'] as List? ?? [];
      for (var lesson in lessons) {
        if (lesson['title'] is! String) {
          debugPrint(
            'Lesson ${lesson['id']} has a title of type ${lesson['title'].runtimeType}: ${lesson['title']}',
          );
        }
      }
    }
  }
}
