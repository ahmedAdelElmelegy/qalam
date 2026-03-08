import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import 'lib/features/curriculum/data/models/culture_model.dart';

void main() async {
  final file = File('assets/data/curriculum_data.json');
  final String response = await file.readAsString();
  final data = json.decode(response);

  final List<dynamic> levelsJson = data['levels'];

  for (var l in levelsJson) {
    try {
      CurriculumLevel.fromJson(l);
    } catch (e, st) {
      debugPrint('Error parsing level ${l['id']}: $e');
      debugPrintStack(stackTrace: st);
    }
  }
}
