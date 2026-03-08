
class ClothingData {
  final List<ClothingModel> clothing;

  ClothingData({required this.clothing});

  factory ClothingData.fromJson(Map<String, dynamic> json) {
    return ClothingData(
      clothing: (json['data'] as List)
          .map((e) => ClothingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ClothingModel {
  final String id;
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, List<String>> details;
  final List<String> gallery;
  final String videoIdea;

  ClothingModel({
    required this.id,
    required this.title,
    required this.description,
    required this.details,
    required this.gallery,
    required this.videoIdea,
  });

  factory ClothingModel.fromJson(Map<String, dynamic> json) {
    return ClothingModel(
      id: json['id'] as String,
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      details: (json['details'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(
          key,
          (value as List).map((e) => e as String).toList(),
        ),
      ),
      gallery: (json['gallery'] as List).map((e) => e as String).toList(),
      videoIdea: json['videoUrl'] as String? ?? json['video_idea'] as String? ?? '',
    );
  }

  String getTitle(String languageCode) {
    if (title.containsKey(languageCode)) {
      return title[languageCode]!;
    }
    final shortCode = languageCode.split('_')[0];
    if (title.containsKey(shortCode)) {
      return title[shortCode]!;
    }
    return title['en'] ?? title.values.first;
  }

  String getDescription(String languageCode) {
    if (description.containsKey(languageCode)) {
      return description[languageCode]!;
    }
    final shortCode = languageCode.split('_')[0];
    if (description.containsKey(shortCode)) {
      return description[shortCode]!;
    }
    return description['en'] ?? description.values.first;
  }

  List<String> getDetails(String languageCode) {
    if (details.containsKey(languageCode)) {
      return details[languageCode]!;
    }
    final shortCode = languageCode.split('_')[0];
    if (details.containsKey(shortCode)) {
      return details[shortCode]!;
    }
    return details['en'] ?? [];
  }
}
