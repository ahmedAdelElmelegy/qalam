import 'package:equatable/equatable.dart';

class VirtualGallaryPlaceModel extends Equatable {
  final String id;
  final String category;
  final VirtualGallaryLocation location;
  final String imageUrl;

  /// Localized names keyed by language code (e.g. "ar", "en").
  /// May be empty `{}` if the backend hasn't stored translations yet.
  final Map<String, String> names;

  /// Localized short descriptions keyed by language code.
  /// May be empty `{}` if the backend hasn't stored translations yet.
  final Map<String, String> shortDescriptions;

  const VirtualGallaryPlaceModel({
    required this.id,
    required this.category,
    required this.location,
    required this.imageUrl,
    required this.names,
    required this.shortDescriptions,
  });

  // ─── Convenience getters ────────────────────────────────────────────────

  /// Returns the name for the given [languageCode], falling back to English,
  /// then Arabic, then the raw id if nothing is available.
  String nameFor(String languageCode) =>
      names[languageCode] ?? names['en'] ?? names['ar'] ?? id;

  /// Returns the short description for the given [languageCode], falling back
  /// to English, then Arabic, then an empty string.
  String descriptionFor(String languageCode) =>
      shortDescriptions[languageCode] ??
      shortDescriptions['en'] ??
      shortDescriptions['ar'] ??
      '';

  // ─── Serialization ──────────────────────────────────────────────────────

  factory VirtualGallaryPlaceModel.fromJson(Map<String, dynamic> json) {
    return VirtualGallaryPlaceModel(
      id: json['id'] as String? ?? '',
      category: json['category'] as String? ?? '',
      location: VirtualGallaryLocation.fromJson(
        json['location'] as Map<String, dynamic>? ?? {},
      ),
      imageUrl: json['imageUrl'] as String? ?? '',
      names: _safeStringMap(json['names']),
      shortDescriptions: _safeStringMap(json['shortDescriptions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'location': location.toJson(),
      'imageUrl': imageUrl,
      'names': names,
      'shortDescriptions': shortDescriptions,
    };
  }

  VirtualGallaryPlaceModel copyWith({
    String? id,
    String? category,
    VirtualGallaryLocation? location,
    String? imageUrl,
    Map<String, String>? names,
    Map<String, String>? shortDescriptions,
  }) {
    return VirtualGallaryPlaceModel(
      id: id ?? this.id,
      category: category ?? this.category,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      names: names ?? this.names,
      shortDescriptions: shortDescriptions ?? this.shortDescriptions,
    );
  }

  @override
  List<Object?> get props => [
    id,
    category,
    location,
    imageUrl,
    names,
    shortDescriptions,
  ];

  // ─── Helpers ────────────────────────────────────────────────────────────

  /// Safely converts a dynamic JSON map to [Map<String, String>],
  /// filtering out null or non-string values.
  static Map<String, String> _safeStringMap(dynamic raw) {
    if (raw == null || raw is! Map) return {};
    final result = <String, String>{};
    for (final entry in raw.entries) {
      if (entry.key is String && entry.value != null) {
        result[entry.key as String] = entry.value.toString();
      }
    }
    return result;
  }
}

/// Embedded location object { "city": "...", "country": "..." }.
class VirtualGallaryLocation extends Equatable {
  final String city;
  final String country;

  const VirtualGallaryLocation({required this.city, required this.country});

  factory VirtualGallaryLocation.fromJson(Map<String, dynamic> json) {
    return VirtualGallaryLocation(
      city: json['city'] as String? ?? '',
      country: json['country'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() => {'city': city, 'country': country};

  @override
  List<Object?> get props => [city, country];
}

/// Wrapper for the full paginated GET /Museum/Place response.
class VirtualGallaryPlacesResponse {
  final bool success;
  final String message;
  final List<VirtualGallaryPlaceModel> data;

  const VirtualGallaryPlacesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VirtualGallaryPlacesResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final places = <VirtualGallaryPlaceModel>[];
    if (rawData is List) {
      for (final item in rawData) {
        if (item is Map<String, dynamic>) {
          places.add(VirtualGallaryPlaceModel.fromJson(item));
        }
      }
    }
    return VirtualGallaryPlacesResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: places,
    );
  }
}
