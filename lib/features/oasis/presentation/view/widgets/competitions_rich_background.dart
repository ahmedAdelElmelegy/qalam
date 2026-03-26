import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CompetitionsRichBackground extends StatelessWidget {
  const CompetitionsRichBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.2,
          colors: [Color(0xFF1A1040), Color(0xFF0A0A1A), Color(0xFF050510)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -80,
            child: _Orb(
              size: 280,
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -60,
            child: _Orb(
              size: 220,
              color: const Color(0xFFEC4899).withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            top: 300,
            right: 50,
            child: _Orb(
              size: 120,
              color: const Color(0xFF10B981).withValues(alpha: 0.08),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;

  const _Orb({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color,
            blurRadius: size * 0.5,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.1, 1.1),
        duration: 4.seconds,
        curve: Curves.easeInOut,
      )
      .moveY(
        begin: 0,
        end: 15,
        duration: 5.seconds,
        curve: Curves.easeInOut,
      );
  }
}
