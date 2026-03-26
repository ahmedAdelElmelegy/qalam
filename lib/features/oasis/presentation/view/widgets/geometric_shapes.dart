import 'dart:math';
import 'package:flutter/material.dart';

class GeometricShapes extends StatelessWidget {
  const GeometricShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 200,
          right: 20,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 0.1),
            duration: const Duration(seconds: 8),
            builder: (context, val, child) => Transform.rotate(
              angle: val,
              child: child,
            ),
            child: GeoShape(
              size: 60,
              color: Colors.white.withValues(alpha: 0.03),
              sides: 6,
            ),
          ),
        ),
        Positioned(
          top: 450,
          left: 10,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: -0.15),
            duration: const Duration(seconds: 6),
            builder: (context, val, child) => Transform.rotate(
              angle: val,
              child: child,
            ),
            child: GeoShape(
              size: 40,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.08),
              sides: 3,
            ),
          ),
        ),
        Positioned(
          bottom: 350,
          right: 30,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.2, end: 0.5),
            duration: const Duration(seconds: 7),
            builder: (context, val, child) => Transform.rotate(
              angle: val,
              child: child,
            ),
            child: GeoShape(
              size: 50,
              color: const Color(0xFFEC4899).withValues(alpha: 0.06),
              sides: 4,
            ),
          ),
        ),
      ],
    );
  }
}

class GeoShape extends StatelessWidget {
  final double size;
  final Color color;
  final int sides;

  const GeoShape({
    super.key,
    required this.size,
    required this.color,
    required this.sides,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PolygonPainter(sides: sides, color: color),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;

  _PolygonPainter({required this.sides, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_PolygonPainter oldDelegate) => false;
}
