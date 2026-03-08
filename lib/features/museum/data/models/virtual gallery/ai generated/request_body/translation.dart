class TranslationPlace {
  final String languageCode;
  final String name;
  final String shortDescription;

  TranslationPlace({
    required this.languageCode,
    required this.name,
    required this.shortDescription,
  });

  factory TranslationPlace.fromJson(Map<String, dynamic> json) {
    return TranslationPlace(
      languageCode: json['languageCode'],
      name: json['name'],
      shortDescription: json['shortDescription'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'name': name,
      'shortDescription': shortDescription,
    };
  }
}
