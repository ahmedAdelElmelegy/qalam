import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/museum/presentation/view/widgets/walking_character.dart';

class TraditionsAvatar extends StatelessWidget {
  final AnimationController avatarController;
  final ui.Path path;
  final double width;
  final double height;

  const TraditionsAvatar({
    super.key,
    required this.avatarController,
    required this.path,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: avatarController,
      builder: (context, child) {
        final metrics = path.computeMetrics().first;
        final currentPos = metrics.length * avatarController.value;
        final nextPos = (currentPos + 10).clamp(0, metrics.length);
        final currentTangent = metrics.getTangentForOffset(currentPos);
        final nextTangent = metrics.getTangentForOffset(nextPos.toDouble());

        final pos = currentTangent?.position ?? Offset(width * 0.5, 0);
        final nextPosition = nextTangent?.position ?? pos;
        final facingRight = nextPosition.dx > pos.dx;
        final isWalking = avatarController.isAnimating;

        return Positioned(
          left: (pos.dx - 30.w).clamp(0.0, width - 60.w),
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
