import 'package:flutter/material.dart';

/// Base class for all exhibits in the museum
abstract class MuseumItem {
  final String id;
  final String title;
  final String description;
  final String icon;

  MuseumItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
  });
}

/// A exhibit category (e.g. Grammar, Vocabulary)
class ExhibitCategory extends MuseumItem {
  final List<LanguageTopic> topics;
  final Color accentColor;

  ExhibitCategory({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required this.topics,
    required this.accentColor,
  });
}

/// A specific language topic (e.g. "Arabic Grammar Rules")
class LanguageTopic {
  final String title;
  final String englishTitle;
  final String content;
  final List<LanguageExample> examples;

  LanguageTopic({
    required this.title,
    required this.englishTitle,
    required this.content,
    required this.examples,
  });
}

/// Concrete example for a grammar rule or vocabulary
class LanguageExample {
  final String arabic;
  final String english;
  final String? audioPath;

  LanguageExample({
    required this.arabic,
    required this.english,
    this.audioPath,
  });
}

/// A real-life place scene (e.g. Restaurant)
class PlaceExhibit extends MuseumItem {
  final String imagePath;
  final List<SceneObject> objects;
  final List<LanguageExample> commonPhrases;

  PlaceExhibit({
    required super.id,
    required super.title,
    required super.description,
    required super.icon,
    required this.imagePath,
    required this.objects,
    required this.commonPhrases,
  });
}

/// An interactive object within a scene
class SceneObject {
  final String id;
  final String arabicName;
  final String englishName;
  final String arabicSentence; // Full sentence in Arabic
  final String englishSentence; // Full sentence in English
  final Offset
  position; // Position in percentage (0.0 to 1.0) for responsive overlay
  final String? icon;

  SceneObject({
    required this.id,
    required this.arabicName,
    required this.englishName,
    required this.arabicSentence,
    required this.englishSentence,
    required this.position,
    this.icon,
  });
}
