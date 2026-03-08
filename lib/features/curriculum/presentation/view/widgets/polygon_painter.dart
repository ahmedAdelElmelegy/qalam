import 'dart:math';
import 'package:flutter/material.dart';

class PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;

  PolygonPainter({required this.sides, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final cx = size.width / 2, cy = size.height / 2, r = size.width / 2;
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final x = cx + r * cos(angle), y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PolygonPainter oldDelegate) =>
      oldDelegate.sides != sides || oldDelegate.color != color;
}
