import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ClothingJourneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const Color pathColor = Color(0xFF10B981);

    final paint = Paint()
      ..color = pathColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.w
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = pathColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28.w
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final centerX = size.width * 0.5;

    final path = Path();
    path.moveTo(centerX, 0);
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

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    final metric = path.computeMetrics().first;
    final dotPaint = Paint()..color = pathColor.withValues(alpha: 0.7);
    final dotGlow = Paint()
      ..color = pathColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (int i = 0; i <= 40; i++) {
      final pos = metric
          .getTangentForOffset(metric.length * (i / 40))
          ?.position;
      if (pos != null) {
        canvas.drawCircle(pos, 4.w, dotGlow);
        canvas.drawCircle(pos, 2.w, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
