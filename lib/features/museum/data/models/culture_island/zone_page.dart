import 'package:equatable/equatable.dart';

/// Zone Page Model
/// Represents a content page within a cultural zone's PageView
class ZonePage extends Equatable {
  final String title;
  final Map<String, String> titleLocalized;
  final Map<String, String> detailedDescriptionLocalized;
  final String imageUrl;
  final String? audioPath;

  const ZonePage({
    required this.title,
    required this.titleLocalized,
    required this.detailedDescriptionLocalized,
    required this.imageUrl,
    this.audioPath,
  });

  String getTitle(String languageCode) {
    if (titleLocalized.containsKey(languageCode)) {
      return titleLocalized[languageCode]!;
    }
    return titleLocalized['en'] ?? title;
  }

  String getDetailedDescription(String languageCode) {
    if (detailedDescriptionLocalized.containsKey(languageCode)) {
      return detailedDescriptionLocalized[languageCode]!;
    }
    return detailedDescriptionLocalized['en'] ?? '';
  }

  @override
  List<Object?> get props => [
        title,
        titleLocalized,
        detailedDescriptionLocalized,
        imageUrl,
        audioPath,
      ];
}
