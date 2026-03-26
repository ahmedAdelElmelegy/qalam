import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ProfileBackgroundOrb extends StatelessWidget {
  final double? top;
  final double? left;
  final double? right;
  final double? bottom;
  final Color color;
  final double size;
  final int delay;

  const ProfileBackgroundOrb({
    super.key,
    this.top,
    this.left,
    this.right,
    this.bottom,
    required this.color,
    required this.size,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.1),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.2),
              blurRadius: size / 2,
              spreadRadius: size / 4,
            ),
          ],
        ),
      )
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .fadeIn(delay: delay.ms, duration: 2.seconds)
          .scale()
          .moveY(
            begin: 0,
            end: 20,
            duration: 4.seconds,
            curve: Curves.easeInOutSine,
          ),
    );
  }
}
