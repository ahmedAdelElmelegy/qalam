import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OasisBackground extends StatelessWidget {
  const OasisBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0D1B2A), Color(0xFF080818), Color(0xFF030308)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -60,
            right: -80,
            child: _Orb(
              size: 280,
              color: const Color(0xFF06B6D4).withValues(alpha: 0.12),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -60,
            child: _Orb(
              size: 220,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.09),
            ),
          ),
          Positioned(
            top: 350,
            left: 50,
            child: _Orb(
              size: 120,
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.08),
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
            spreadRadius: size * 0.08,
          ),
        ],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
      .scale(
        begin: const Offset(1, 1),
        end: const Offset(1.12, 1.12),
        duration: 5.seconds,
        curve: Curves.easeInOut,
      )
      .moveY(
        begin: 0,
        end: 12,
        duration: 4.seconds,
        curve: Curves.easeInOut,
      );
  }
}
