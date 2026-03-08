import 'dart:math';

import 'package:flutter/material.dart';

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  final List<Particle> particles;

  ParticlesPainter(this.animationValue)
    : particles = List.generate(
        50,
        (index) => Particle(
          x: Random(index).nextDouble(),
          y: Random(index * 2).nextDouble(),
          size: Random(index * 3).nextDouble() * 3 + 1,
          speed: Random(index * 4).nextDouble() * 0.5 + 0.2,
        ),
      );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    for (var particle in particles) {
      final x = particle.x * size.width;
      final y =
          ((particle.y + animationValue * particle.speed) % 1.0) * size.height;

      canvas.drawCircle(
        Offset(x, y),
        particle.size,
        paint
          ..color = Colors.white.withValues(
            alpha: 0.2 + Random(particle.hashCode).nextDouble() * 0.3,
          ),
      );
    }
  }

  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

class Particle {
  final double x;
  final double y;
  final double size;
  final double speed;

  Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
  });
}
