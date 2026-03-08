import 'package:arabic/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JourneyPathPainter extends CustomPainter {
  /// Centralized path creation logic
  static Path buildPath(Size size) {
    final path = Path();
    path.moveTo(size.width * 0.5, 0);
    // Enhanced S-curve path
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.2,
      size.width * 0.15,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.45,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.6,
      size.width * 0.15,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.lineTo(size.width * 0.5, size.height);
    return path;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.w
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 24.w
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 15);

    final path = buildPath(size);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    // Draw trail dots
    final metric = path.computeMetrics().first;
    final dotPaint = Paint()..color = AppColors.accentGold.withValues(alpha: 0.8);
    final dotGlow = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    // Increase dot density for a better "trail" look
    for (int i = 0; i <= 60; i++) {
      final pos = metric
          .getTangentForOffset(metric.length * (i / 60))
          ?.position;
      if (pos != null) {
        canvas.drawCircle(pos, 4.w, dotGlow);
        canvas.drawCircle(pos, 2.w, dotPaint);
      }
    }

    // Start/End Points
    final startPos = metric.getTangentForOffset(0)?.position;
    final endPos = metric.getTangentForOffset(metric.length)?.position;
    final markerPaint = Paint()..color = AppColors.accentGold;

    if (startPos != null) canvas.drawCircle(startPos, 8.w, markerPaint);
    if (endPos != null) canvas.drawCircle(endPos, 8.w, markerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
