import 'dart:ui';
import 'package:equatable/equatable.dart';

class CultureContent extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final Color baseColor;
  final List<CultureSection> sections;

  const CultureContent({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.baseColor,
    required this.sections,
  });

  @override
  List<Object?> get props => [id, title, description, imageUrl, baseColor, sections];
}

class CultureSection extends Equatable {
  final String title;
  final String content;
  final String? imageUrl;
  final List<String> bulletPoints;

  const CultureSection({
    required this.title,
    required this.content,
    this.imageUrl,
    this.bulletPoints = const [],
  });

  @override
  List<Object?> get props => [title, content, imageUrl, bulletPoints];
}
