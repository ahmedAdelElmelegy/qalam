import 'package:flutter/material.dart';

class CompData {
  final String typeId;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final double progress;
  final String? badge;

  CompData({
    required this.typeId,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.progress,
    this.badge,
  });
}
