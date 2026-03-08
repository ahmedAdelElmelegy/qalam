class HistoryResponse {
  final bool success;
  final String message;
  final List<HistoryPeriodModel> data;

  HistoryResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory HistoryResponse.fromJson(Map<String, dynamic> json) {
    return HistoryResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((e) => HistoryPeriodModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class HistoryPeriodModel {
  final String id;
  final String imageUrl;
  final Map<String, String> yearRange;
  final Map<String, String> title;
  final Map<String, String> description;
  final Map<String, List<String>> detailedDescription;

  HistoryPeriodModel({
    required this.id,
    required this.imageUrl,
    required this.yearRange,
    required this.title,
    required this.description,
    required this.detailedDescription,
  });

  factory HistoryPeriodModel.fromJson(Map<String, dynamic> json) {
    return HistoryPeriodModel(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      yearRange: Map<String, String>.from(json['yearRange'] as Map),
      title: Map<String, String>.from(json['title'] as Map),
      description: Map<String, String>.from(json['description'] as Map),
      detailedDescription: (json['detailedDescription'] as Map).map(
        (key, value) => MapEntry(
          key as String,
          (value as List).map((e) => e as String).toList(),
        ),
      ),
    );
  }

  String getTitle(String languageCode) {
    return title[languageCode] ?? title['en'] ?? title.values.first;
  }

  String getDescription(String languageCode) {
    return description[languageCode] ?? description['en'] ?? description.values.first;
  }

  String getYearRange(String languageCode) {
    return yearRange[languageCode] ?? yearRange['en'] ?? yearRange.values.first;
  }

  List<String> getDetailedDescription(String languageCode) {
    return detailedDescription[languageCode] ?? detailedDescription['en'] ?? [];
  }
}
