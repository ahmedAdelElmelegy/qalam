import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Reusable slide animation for list items
class SlideInAnimation extends StatelessWidget {
  final Widget child;
  final int index;
  final Duration delay;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.index = 0,
    this.delay = const Duration(milliseconds: 50),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate()
        .fadeIn(duration: 300.ms, delay: (delay.inMilliseconds * index).ms)
        .slideX(
          begin: 0.2,
          end: 0,
          duration: 300.ms,
          delay: (delay.inMilliseconds * index).ms,
        );
  }
}

/// Scale animation for buttons and interactive elements
class ScaleAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const ScaleAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  Widget build(BuildContext context) {
    return child.animate().scale(
      duration: duration,
      curve: Curves.easeOutCubic,
    );
  }
}

/// Shimmer effect for loading states
class ShimmerLoading extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerLoading({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
      child:
          Container(
                decoration: BoxDecoration(
                  borderRadius: borderRadius ?? BorderRadius.circular(8),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.2),
                      Colors.white.withValues(alpha: 0.1),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .shimmer(
                duration: 1500.ms,
                color: Colors.white.withValues(alpha: 0.3),
              ),
    );
  }
}

/// Pulse animation for attention-grabbing elements
class PulseAnimation extends StatelessWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 1000),
  });

  @override
  Widget build(BuildContext context) {
    return child
        .animate(onPlay: (controller) => controller.repeat(reverse: true))
        .scale(
          begin: const Offset(1.0, 1.0),
          end: const Offset(1.05, 1.05),
          duration: duration,
          curve: Curves.easeInOut,
        );
  }
}
