import 'package:arabic/features/curriculum/presentation/view/widgets/polygon_painter.dart';
import 'package:flutter/material.dart';

class LevelShapes extends StatelessWidget {
  const LevelShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 250,
          right: 15,
          child: CustomPaint(
            size: const Size(55, 55),
            painter: PolygonPainter(
              sides: 6,
              color: Colors.white.withValues(alpha: 0.03),
            ),
          ),
        ),
        Positioned(
          top: 480,
          left: 20,
          child: CustomPaint(
            size: const Size(40, 40),
            painter: PolygonPainter(
              sides: 3,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.07),
            ),
          ),
        ),
        Positioned(
          bottom: 200,
          right: 40,
          child: CustomPaint(
            size: const Size(35, 35),
            painter: PolygonPainter(
              sides: 4,
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
