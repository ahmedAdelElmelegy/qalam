import 'package:equatable/equatable.dart';

/// Cultural Content Model
/// Represents cultural content (traditions, food, etc.)
class CulturalContentModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String categoryId;
  final String mediaType; // image, video, text
  final String? mediaUrl;

  const CulturalContentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.mediaType,
    this.mediaUrl,
  });

  @override
  List<Object?> get props => [id, title, description, categoryId, mediaType, mediaUrl];
}
