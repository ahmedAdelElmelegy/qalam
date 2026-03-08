import 'package:arabic/features/museum/data/models/museum_object_model.dart';
import 'package:arabic/features/museum/data/models/museum_place_model.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/model/virsual_gallary_place_model.dart';
import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/model/virsual_gallary_sentance_model.dart';

/// Converts backend API models into the UI [MuseumPlaceModel] / [MuseumObjectModel]
/// used throughout the gallery screens.
extension VirtualGallaryPlaceMapper on VirtualGallaryPlaceModel {
  MuseumPlaceModel toMuseumPlaceModel() {
    return MuseumPlaceModel(
      id: id,
      name: names['en'] ?? names['ar'] ?? id,
      description: shortDescriptions['en'] ?? shortDescriptions['ar'] ?? '',
      iconName: _iconForCategory(category),
      imageUrl: imageUrl,
      objects: const [],
      category: category,
      location: {'city': location.city, 'country': location.country},
      localizedNames: names,
      localizedDescriptions: shortDescriptions,
    );
  }
}

extension VirtualGallarySentanceMapper on VirtualGallarySentanceModel {
  MuseumObjectModel toMuseumObjectModel() {
    return MuseumObjectModel(
      id: id,
      icon: 'star',
      localizedNames: texts,
      arabicName: texts['ar'] ?? '',
      englishTranslation: texts['en'] ?? '',
      imageUrl: imageUrl,
    );
  }
}

/// Returns a Material icon name that best matches a place category.
String _iconForCategory(String category) {
  switch (category.toLowerCase()) {
    case 'restaurant':
      return 'restaurant';
    case 'cafe':
      return 'local_cafe';
    case 'museum':
      return 'museum';
    case 'library':
      return 'local_library';
    case 'park':
      return 'park';
    case 'beach':
      return 'beach_access';
    case 'market':
      return 'storefront';
    case 'hotel':
      return 'hotel';
    case 'train_station':
      return 'train';
    case 'theater':
      return 'theaters';
    case 'hospital':
      return 'local_hospital';
    case 'gym':
      return 'fitness_center';
    case 'mountain_trail':
      return 'landscape';
    case 'archaeological_site':
      return 'account_balance';
    default:
      return 'place';
  }
}
