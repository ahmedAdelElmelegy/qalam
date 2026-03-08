import 'package:equatable/equatable.dart';

/// Culture Page Model
/// Represents a single page within a cultural zone PageView
class CulturePage extends Equatable {
  final String id;
  final String zoneId;
  final String title;
  final Map<String, String> contentLocalized;
  final String imageUrl;
  final String? audioUrl;

  const CulturePage({
    required this.id,
    required this.zoneId,
    required this.title,
    required this.contentLocalized,
    required this.imageUrl,
    this.audioUrl,
  });

  String getContent(String languageCode) {
    if (contentLocalized.containsKey(languageCode)) {
      return contentLocalized[languageCode]!;
    }
    return contentLocalized['en'] ?? '';
  }

  @override
  List<Object?> get props => [id, zoneId, title, contentLocalized, imageUrl, audioUrl];
}
