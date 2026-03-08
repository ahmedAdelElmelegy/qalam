import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;
import 'package:arabic/core/theme/colors.dart';

class Background3D extends StatefulWidget {
  const Background3D({super.key});

  @override
  State<Background3D> createState() => _Background3DState();
}

class _Background3DState extends State<Background3D>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = List.generate(20, (index) => Particle());

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          children: [
            // Deep Navy Background
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryDark,
                    AppColors.primaryNavy,
                    AppColors.primaryDark,
                  ],
                ),
              ),
            ),

            // Floating Orbs
            ...List.generate(3, (index) {
              final angle = _controller.value * 2 * math.pi + (index * 2);
              return Positioned(
                left: 100.w + math.cos(angle) * 150.w,
                top: 300.h + math.sin(angle) * 100.h,
                child: Container(
                  width: 200.w,
                  height: 200.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.accentGold.withValues(alpha: 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            }),

            // Floating Particles
            CustomPaint(
              size: Size.infinite,
              painter: ParticlePainter(
                particles: _particles,
                progress: _controller.value,
              ),
            ),
          ],
        );
      },
    );
  }
}

class Particle {
  double x = math.Random().nextDouble();
  double y = math.Random().nextDouble();
  double size = math.Random().nextDouble() * 2 + 1;
  double speed = math.Random().nextDouble() * 0.1 + 0.05;
  double opacity = math.Random().nextDouble() * 0.5 + 0.2;
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final double progress;

  ParticlePainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.accentGold;

    for (var particle in particles) {
      final yPos = ((particle.y - (progress * particle.speed)) % 1.0) * size.height;
      final xPos = particle.x * size.width;

      paint.color = AppColors.accentGold.withValues(alpha: particle.opacity);
      canvas.drawCircle(Offset(xPos, yPos), particle.size.w, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
