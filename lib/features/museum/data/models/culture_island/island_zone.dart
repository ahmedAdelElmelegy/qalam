import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'zone_page.dart';

/// Island Zone Model
/// Represents an interactive 3D landmark on the culture island
class IslandZone extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon3DPath; // Key for the 3D-like icon
  final Offset position;   // Relative coordinates (0.0 to 1.0)
  final List<ZonePage> pages;

  const IslandZone({
    required this.id,
    required this.title,
    required this.description,
    required this.icon3DPath,
    required this.position,
    this.pages = const [],
  });

  @override
  List<Object?> get props => [id, title, description, icon3DPath, position, pages];
}
