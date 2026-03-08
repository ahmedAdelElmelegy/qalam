import 'package:equatable/equatable.dart';

/// A single sentence item returned by GET /Museum/Place/{placeCode}/Sentence.
///
/// ```json
/// {
///   "id": "...",
///   "imageUrl": "https://res.cloudinary.com/...",
///   "texts": { "ar": "...", "en": "...", "fr": "...", "de": "...", "zh": "...", "ru": "..." }
/// }
/// ```
class VirtualGallarySentanceModel extends Equatable {
  final String id;
  final String imageUrl;

  /// Localized texts keyed by language code (ar, en, fr, de, zh, ru…).
  final Map<String, String> texts;

  const VirtualGallarySentanceModel({
    required this.id,
    required this.imageUrl,
    required this.texts,
  });

  // ─── Convenience ────────────────────────────────────────────────────────

  /// Returns the text for [languageCode], falling back to English → Arabic → ''.
  String textFor(String languageCode) =>
      texts[languageCode] ?? texts['en'] ?? texts['ar'] ?? '';

  // ─── Serialization ──────────────────────────────────────────────────────

  factory VirtualGallarySentanceModel.fromJson(Map<String, dynamic> json) {
    return VirtualGallarySentanceModel(
      id: json['id'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      texts: _safeStringMap(json['texts']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'imageUrl': imageUrl,
    'texts': texts,
  };

  VirtualGallarySentanceModel copyWith({
    String? id,
    String? imageUrl,
    Map<String, String>? texts,
  }) {
    return VirtualGallarySentanceModel(
      id: id ?? this.id,
      imageUrl: imageUrl ?? this.imageUrl,
      texts: texts ?? this.texts,
    );
  }

  @override
  List<Object?> get props => [id, imageUrl, texts];

  // ─── Helper ─────────────────────────────────────────────────────────────

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

/// Paginated wrapper for GET /Museum/Place/{placeCode}/Sentence.
///
/// ```json
/// {
///   "success": true,
///   "message": "Sentences retrieved successfully",
///   "data": {
///     "items": [...],
///     "totalCount": 3,
///     "pageNumber": 1,
///     "pageSize": 10,
///     "totalPages": 1
///   }
/// }
/// ```
class VirtualGallarySentancesResponse {
  final bool success;
  final String message;
  final VirtualGallarySentancesPage data;

  const VirtualGallarySentancesResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory VirtualGallarySentancesResponse.fromJson(Map<String, dynamic> json) {
    return VirtualGallarySentancesResponse(
      success: json['success'] as bool? ?? false,
      message: json['message'] as String? ?? '',
      data: VirtualGallarySentancesPage.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}

/// The paginated data block inside [VirtualGallarySentancesResponse].
class VirtualGallarySentancesPage extends Equatable {
  final List<VirtualGallarySentanceModel> items;
  final int totalCount;
  final int pageNumber;
  final int pageSize;
  final int totalPages;

  const VirtualGallarySentancesPage({
    required this.items,
    required this.totalCount,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  bool get hasNextPage => pageNumber < totalPages;

  factory VirtualGallarySentancesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = <VirtualGallarySentanceModel>[];
    if (rawItems is List) {
      for (final item in rawItems) {
        if (item is Map<String, dynamic>) {
          items.add(VirtualGallarySentanceModel.fromJson(item));
        }
      }
    }
    return VirtualGallarySentancesPage(
      items: items,
      totalCount: json['totalCount'] as int? ?? 0,
      pageNumber: json['pageNumber'] as int? ?? 1,
      pageSize: json['pageSize'] as int? ?? 10,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  @override
  List<Object?> get props => [
    items,
    totalCount,
    pageNumber,
    pageSize,
    totalPages,
  ];
}
