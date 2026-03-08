class VirtualGallerySentenceRequest {
  final String code;
  final String imageUrl;
  final List<TranslationSentence> translations;

  VirtualGallerySentenceRequest({
    required this.code,
    required this.imageUrl,
    required this.translations,
  });

  factory VirtualGallerySentenceRequest.fromJson(Map<String, dynamic> json) {
    return VirtualGallerySentenceRequest(
      code: json['code'],
      imageUrl: json['imageUrl'],
      translations: List<TranslationSentence>.from(
        json['translations'].map((x) => TranslationSentence.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'imageUrl': imageUrl,
      'translations': translations.map((x) => x.toJson()).toList(),
    };
  }
}

class TranslationSentence {
  final String languageCode;
  final String text;

  TranslationSentence({
    required this.languageCode,
    required this.text,
  });

  factory TranslationSentence.fromJson(Map<String, dynamic> json) {
    return TranslationSentence(
      languageCode: json['languageCode'],
      text: json['text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'languageCode': languageCode,
      'text': text,
    };
  }
}
