import 'package:equatable/equatable.dart';

/// Museum Object Model
/// Represents an object inside a museum place for vocabulary learning
class MuseumObjectModel extends Equatable {
  final String id;
  final String icon;
  final Map<String, String> localizedNames; // Names in all languages
  final Map<String, String> localizedTranslations; // Translations in all languages
  final Map<String, String> localizedSentences; // Sentences in all languages

  // Target language fields (Arabic in this case)
  final String arabicName;
  final String arabicSentence;
  final String pronunciation;
  
  // Legacy/Compatibility fields (optional)
  final String englishTranslation;
  final String englishSentence;
  
  final String imageUrl;
  final double positionX;
  final double positionY;

  const MuseumObjectModel({
    required this.id,
    required this.icon,
    required this.localizedNames,
    this.localizedTranslations = const {},
    this.localizedSentences = const {},
    this.arabicName = '',
    this.arabicSentence = '',
    this.pronunciation = '',
    this.englishTranslation = '',
    this.englishSentence = '',
    this.imageUrl = '',
    this.positionX = 0.0,
    this.positionY = 0.0,
  });

  @override
  List<Object?> get props => [
    id,
    icon,
    localizedNames,
    localizedTranslations,
    localizedSentences,
    arabicName,
    arabicSentence,
    pronunciation,
    englishTranslation,
    englishSentence,
    imageUrl,
    positionX,
    positionY,
  ];
}

