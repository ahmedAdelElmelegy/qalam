import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/colors.dart';

class HistoryJourneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.w
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.w
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final centerX = size.width * 0.5;
    final curveX = size.width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      centerX + curveX,
      size.height * 0.2,
      centerX - curveX,
      size.height * 0.4,
      centerX,
      size.height * 0.5,
    );
    path.cubicTo(
      centerX + curveX,
      size.height * 0.6,
      centerX - curveX,
      size.height * 0.8,
      centerX,
      size.height * 1.0,
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    // Trail dots
    final metric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.5);
    for (int i = 0; i <= 30; i++) {
      final pos = metric
          .getTangentForOffset(metric.length * (i / 30))
          ?.position;
      if (pos != null) canvas.drawCircle(pos, 2.0.w, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
