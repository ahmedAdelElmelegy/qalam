import 'package:equatable/equatable.dart';
import 'museum_object_model.dart';

/// Museum Place Model
/// Represents a place in the Virtual Museum (e.g., Restaurant, Train Station)
class MuseumPlaceModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconName;
  final String imageUrl;
  final List<MuseumObjectModel> objects;

  final String category;
  final Map<String, String> location;
  final Map<String, String> localizedNames;
  final Map<String, String> localizedDescriptions;
  final Map<String, List<String>> detailedSentences;

  const MuseumPlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
    required this.imageUrl,
    required this.objects,
    this.category = 'museum',
    this.location = const {},
    this.localizedNames = const {},
    this.localizedDescriptions = const {},
    this.detailedSentences = const {},
  });

  MuseumPlaceModel copyWith({
    String? id,
    String? name,
    String? description,
    String? iconName,
    String? imageUrl,
    List<MuseumObjectModel>? objects,
    String? category,
    Map<String, String>? location,
    Map<String, String>? localizedNames,
    Map<String, String>? localizedDescriptions,
    Map<String, List<String>>? detailedSentences,
  }) {
    return MuseumPlaceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      iconName: iconName ?? this.iconName,
      imageUrl: imageUrl ?? this.imageUrl,
      objects: objects ?? this.objects,
      category: category ?? this.category,
      location: location ?? this.location,
      localizedNames: localizedNames ?? this.localizedNames,
      localizedDescriptions: localizedDescriptions ?? this.localizedDescriptions,
      detailedSentences: detailedSentences ?? this.detailedSentences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        iconName,
        imageUrl,
        objects,
        category,
        location,
        localizedNames,
        localizedDescriptions,
        detailedSentences,
      ];
}
