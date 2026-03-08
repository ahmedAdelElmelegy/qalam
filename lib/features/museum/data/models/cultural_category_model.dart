import 'package:equatable/equatable.dart';

/// Cultural Category Model
/// Represents a category in the cultural exploration section
class CulturalCategoryModel extends Equatable {
  final String id;
  final String name;
  final String iconName;
  final String description;

  const CulturalCategoryModel({
    required this.id,
    required this.name,
    required this.iconName,
    required this.description,
  });

  @override
  List<Object?> get props => [id, name, iconName, description];
}
