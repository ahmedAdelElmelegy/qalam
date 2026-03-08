import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PathPainter extends CustomPainter {
  final int lessonCount;

  PathPainter({required this.lessonCount});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final dashLength = 10.0;
    final dashGap = 8.0;

    final path = Path();
    final startX = 24.w + 25.w; // left node position
    final rightX = size.width - 24.w - 25.w; // right node position
    final nodeVerticalStep = 50.w + 8.h + 60.h + 40.h; // rough estimation of node vertical spacing

    double currentY = 40.h + 25.w;
    path.moveTo(startX, currentY);

    for (int i = 0; i < lessonCount - 1; i++) {
      final fromX = i % 2 == 0 ? startX : rightX;
      final toX = (i + 1) % 2 == 0 ? startX : rightX;
      final nextY = currentY + nodeVerticalStep;

      // Draw a curve between nodes
      path.cubicTo(
        fromX,
        currentY + nodeVerticalStep * 0.4,
        toX,
        nextY - nodeVerticalStep * 0.4,
        toX,
        nextY,
      );
      currentY = nextY;
    }

    _drawDashedPath(canvas, path, paint, dashLength, dashGap);
  }

  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashLength,
    double dashGap,
  ) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final length = min(dashLength, metric.length - distance);
        final dashPath = metric.extractPath(distance, distance + length);
        canvas.drawPath(dashPath, paint);
        distance += dashLength + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
