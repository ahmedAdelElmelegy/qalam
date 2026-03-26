import 'package:flutter/material.dart';

class OasisFeature {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final String routeId;

  OasisFeature({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.routeId,
  });
}
