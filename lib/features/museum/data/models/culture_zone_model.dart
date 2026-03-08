import 'package:equatable/equatable.dart';

/// Culture Zone Model
/// Represents a category/zone in the Arabic Culture Island (e.g., Food, Clothing)
class CultureZone extends Equatable {
  final String id;
  final String title;
  final String titleAr;
  final String description;
  final String iconName;
  final String imageUrl;

  const CultureZone({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.description,
    required this.iconName,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, titleAr, description, iconName, imageUrl];
}
