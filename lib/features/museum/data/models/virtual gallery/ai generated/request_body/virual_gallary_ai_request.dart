import 'package:arabic/features/museum/data/models/virtual%20gallery/ai%20generated/request_body/translation.dart';

class VirtualGalleryPlaceAiRequest {
  final String code;
  final String category;
  final String city;
  final String country;
  final String imageUrl;
  final List<TranslationPlace> translations;

  VirtualGalleryPlaceAiRequest({
    required this.code,
    required this.category,
    required this.city,
    required this.country,
    required this.imageUrl,
    required this.translations,
  });

  factory VirtualGalleryPlaceAiRequest.fromJson(Map<String, dynamic> json) {
    return VirtualGalleryPlaceAiRequest(
      code: json['code'],
      category: json['category'],
      city: json['city'],
      country: json['country'],
      imageUrl: json['imageUrl'],
      translations: (json['translations'] as List<dynamic>)
          .map((e) => TranslationPlace.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'category': category,
      'city': city,
      'country': country,
      'imageUrl': imageUrl,
      'translations': translations.map((e) => e.toJson()).toList(),
    };
  }
}
