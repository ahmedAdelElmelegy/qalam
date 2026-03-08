import 'package:arabic/features/museum/presentation/view/widgets/culture_island/journey_path_painter.dart';
import 'package:arabic/features/museum/presentation/view/widgets/walking_character.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CulturePathAvatar extends StatelessWidget {
  final AnimationController controller;
  final Size size;

  const CulturePathAvatar({
    super.key,
    required this.controller,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final path = JourneyPathPainter.buildPath(size);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final metrics = path.computeMetrics().first;
        final currentPos = metrics.length * controller.value;

        // Get current and next positions to determine direction
        final nextPos = (currentPos + 10).clamp(0, metrics.length);
        final currentTangent = metrics.getTangentForOffset(currentPos);
        final nextTangent = metrics.getTangentForOffset(nextPos.toDouble());

        final pos =
            currentTangent?.position ?? Offset(size.width * 0.5, 0);
        final nextPosition = nextTangent?.position ?? pos;

        // Determine if character is facing right (moving right) or left
        final facingRight = nextPosition.dx > pos.dx;

        // Check if character is moving (velocity > threshold)
        final isWalking = controller.isAnimating;

        return Positioned(
          left: pos.dx - 30.w,
          top: pos.dy - 80.h,
          child: WalkingCharacter(
            isWalking: isWalking,
            facingRight: facingRight,
          ),
        );
      },
    );
  }
}
