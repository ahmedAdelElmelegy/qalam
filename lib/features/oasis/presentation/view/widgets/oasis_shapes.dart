import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'geometric_shapes.dart';

class OasisShapes extends StatelessWidget {
  const OasisShapes({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 220,
          right: 18,
          child: GeoShape(
            size: 55,
            sides: 6,
            color: Colors.white.withValues(alpha: 0.03),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(
                begin: 0,
                end: 0.12,
                duration: 9.seconds,
              ),
        ),
        Positioned(
          top: 500,
          left: 15,
          child: GeoShape(
            size: 38,
            sides: 3,
            color: const Color(0xFF06B6D4).withValues(alpha: 0.08),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(
                begin: 0,
                end: -0.2,
                duration: 7.seconds,
              ),
        ),
        Positioned(
          bottom: 250,
          right: 35,
          child: GeoShape(
            size: 45,
            sides: 4,
            color: const Color(0xFFF59E0B).withValues(alpha: 0.07),
          ).animate(onPlay: (c) => c.repeat(reverse: true)).rotate(
                begin: 0.1,
                end: 0.4,
                duration: 8.seconds,
              ),
        ),
      ],
    );
  }
}
