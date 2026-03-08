import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LevelBackground extends StatelessWidget {
  const LevelBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D0B28), Color(0xFF050510), Color(0xFF0A090F)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -60,
            child: _Orb(
              size: 300,
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.1),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -80,
            child: _Orb(
              size: 200,
              color: const Color(0xFFD4AF37).withValues(alpha: 0.07),
            ),
          ),
          Positioned(
            top: 350,
            left: 80,
            child: _Orb(
              size: 100,
              color: const Color(0xFF3B82F6).withValues(alpha: 0.07),
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
            blurRadius: size * 0.6,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(1.15, 1.15),
          duration: 5.seconds,
          curve: Curves.easeInOut,
        );
  }
}
