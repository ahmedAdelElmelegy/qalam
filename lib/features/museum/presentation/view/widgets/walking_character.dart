import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math' as math;

/// Animated walking character widget with sprite-like animation
/// Uses custom painting to create a simple walking animation effect
class WalkingCharacter extends StatefulWidget {
  final bool isWalking;
  final bool facingRight;

  const WalkingCharacter({
    super.key,
    this.isWalking = true,
    this.facingRight = true,
  });

  @override
  State<WalkingCharacter> createState() => _WalkingCharacterState();
}

class _WalkingCharacterState extends State<WalkingCharacter>
    with SingleTickerProviderStateMixin {
  late AnimationController _walkController;

  @override
  void initState() {
    super.initState();
    _walkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    if (widget.isWalking) {
      _walkController.repeat();
    }
  }

  @override
  void didUpdateWidget(WalkingCharacter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isWalking && !_walkController.isAnimating) {
      _walkController.repeat();
    } else if (!widget.isWalking && _walkController.isAnimating) {
      _walkController.stop();
      _walkController.value = 0;
    }
  }

  @override
  void dispose() {
    _walkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _walkController,
      builder: (context, child) {
        final walkCycle = _walkController.value;

        return Transform.scale(
          scaleX: widget.facingRight ? 1 : -1,
          child: CustomPaint(
            size: Size(60.w, 80.w),
            painter: _CharacterPainter(walkCycle: walkCycle),
          ),
        );
      },
    );
  }
}

class _CharacterPainter extends CustomPainter {
  final double walkCycle;

  _CharacterPainter({required this.walkCycle});

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Animation calculations
    final leftLegAngle = math.sin(walkCycle * 2 * math.pi) * 0.4;
    final rightLegAngle = math.sin((walkCycle * 2 * math.pi) + math.pi) * 0.4;
    final leftArmAngle = math.sin((walkCycle * 2 * math.pi) + math.pi) * 0.3;
    final rightArmAngle = math.sin(walkCycle * 2 * math.pi) * 0.3;
    final bobOffset = math.sin(walkCycle * 4 * math.pi).abs() * 3;
    final ghutraFlow = math.sin(walkCycle * 2 * math.pi) * 3.w;

    // Paints
    final skinPaint = Paint()..color = const Color(0xFFFFDBAC)..style = PaintingStyle.fill;
    final shoePaint = Paint()..color = const Color(0xFF8D6E63)..style = PaintingStyle.fill;
    final thobePaint = Paint()..color = const Color(0xFFF8F9FA)..style = PaintingStyle.fill;
    final thobeShadowPaint = Paint()..color = const Color(0xFFE9ECEF)..style = PaintingStyle.fill;
    final ghutraPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
    final agalPaint = Paint()
      ..color = const Color(0xFF1E1E1E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5.w
      ..strokeCap = StrokeCap.round;

    // === SHADOW ===
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(
      Rect.fromCenter(
          center: Offset(centerX, centerY + 38.h), width: 35.w + bobOffset * 2, height: 8.h),
      shadowPaint,
    );

    canvas.save();
    canvas.translate(0, -bobOffset);

    // === BACK ARM (Right Arm) ===
    canvas.save();
    canvas.translate(centerX + 6.w, centerY - 6.h);
    canvas.rotate(rightArmAngle);
    // Sleeve
    canvas.drawRRect(
        RRect.fromLTRBR(-4.w, -2.h, 4.w, 18.h, Radius.circular(4.w)), thobeShadowPaint);
    // Hand
    canvas.drawCircle(Offset(0, 18.h), 3.5.w, skinPaint);
    canvas.restore();

    // === BACK LEG (Right Leg) ===
    canvas.save();
    canvas.translate(centerX + 4.w, centerY + 18.h);
    canvas.rotate(rightLegAngle);
    // Leg/Pants
    canvas.drawRRect(RRect.fromLTRBR(-3.5.w, 0, 3.5.w, 15.h, Radius.circular(3.w)), skinPaint);
    // Shoe
    canvas.drawRRect(RRect.fromLTRBR(-5.w, 12.h, 6.w, 18.h, Radius.circular(4.w)), shoePaint);
    canvas.restore();

    // === FRONT LEG (Left Leg) ===
    canvas.save();
    canvas.translate(centerX - 4.w, centerY + 18.h);
    canvas.rotate(leftLegAngle);
    // Leg/Pants
    canvas.drawRRect(RRect.fromLTRBR(-3.5.w, 0, 3.5.w, 15.h, Radius.circular(3.w)), skinPaint);
    // Shoe
    canvas.drawRRect(RRect.fromLTRBR(-6.w, 12.h, 5.w, 18.h, Radius.circular(4.w)), shoePaint);
    canvas.restore();

    // === BODY (Thobe) ===
    final bodyPath = Path()
      ..moveTo(centerX - 10.w, centerY - 10.h) // Top left shoulder
      ..lineTo(centerX + 10.w, centerY - 10.h) // Top right shoulder
      ..quadraticBezierTo(centerX + 16.w, centerY + 5.h, centerX + 14.w, centerY + 24.h) // Right side
      ..quadraticBezierTo(centerX, centerY + 26.h, centerX - 14.w, centerY + 24.h) // Bottom curve
      ..quadraticBezierTo(centerX - 16.w, centerY + 5.h, centerX - 10.w, centerY - 10.h) // Left side
      ..close();

    // Body shadow for depth
    final bodyShadowPath = Path()
      ..moveTo(centerX, centerY - 10.h)
      ..lineTo(centerX + 10.w, centerY - 10.h)
      ..quadraticBezierTo(centerX + 16.w, centerY + 5.h, centerX + 14.w, centerY + 24.h)
      ..quadraticBezierTo(centerX + 7.w, centerY + 25.h, centerX, centerY + 25.h)
      ..close();

    canvas.drawPath(bodyPath, thobePaint);
    canvas.drawPath(bodyShadowPath, thobeShadowPaint);

    // Collar
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(centerX, centerY - 10.h), width: 10.w, height: 4.h),
            Radius.circular(2.w)),
        thobePaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset(centerX, centerY - 12.h), width: 8.w, height: 4.h),
            Radius.circular(2.w)),
        skinPaint);

    // === FRONT ARM (Left Arm) ===
    canvas.save();
    canvas.translate(centerX - 6.w, centerY - 6.h);
    canvas.rotate(leftArmAngle);
    // Sleeve
    canvas.drawRRect(RRect.fromLTRBR(-4.w, -2.h, 4.w, 18.h, Radius.circular(4.w)), thobePaint);
    // Hand
    canvas.drawCircle(Offset(0, 18.h), 3.5.w, skinPaint);
    canvas.restore();

    // === HEAD & FACE ===
    // Face base
    canvas.drawCircle(Offset(centerX, centerY - 22.h), 11.w, skinPaint);

    // Rosy Cheeks
    final cheekPaint = Paint()..color = const Color(0xFFFFB6C1).withValues(alpha: 0.6);
    canvas.drawCircle(Offset(centerX - 6.w, centerY - 18.h), 2.w, cheekPaint);
    canvas.drawCircle(Offset(centerX + 6.w, centerY - 18.h), 2.w, cheekPaint);

    // Eyes
    final eyePaint = Paint()..color = const Color(0xFF2C3E50);
    canvas.drawCircle(Offset(centerX - 4.w, centerY - 21.h), 1.5.w, eyePaint);
    canvas.drawCircle(Offset(centerX + 4.w, centerY - 21.h), 1.5.w, eyePaint);

    // Cute Smile
    final smilePaint = Paint()
      ..color = const Color(0xFF2C3E50)
      ..strokeWidth = 1.2.w
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final smilePath = Path()
      ..moveTo(centerX - 3.w, centerY - 16.h)
      ..quadraticBezierTo(centerX, centerY - 13.h, centerX + 3.w, centerY - 16.h);
    canvas.drawPath(smilePath, smilePaint);

    // === GHUTRA (Traditional Headwear) ===
    final ghutraPath = Path()
      ..moveTo(centerX - 13.w, centerY - 22.h)
      ..quadraticBezierTo(centerX, centerY - 38.h, centerX + 13.w, centerY - 22.h) // Top dome
      ..quadraticBezierTo(centerX + 18.w + ghutraFlow, centerY - 5.h, centerX + 16.w + ghutraFlow, centerY + 6.h) // Right drape
      ..lineTo(centerX + 10.w + ghutraFlow, centerY + 6.h)
      ..quadraticBezierTo(centerX + 12.w, centerY - 10.h, centerX + 11.w, centerY - 20.h) // Inner right
      ..lineTo(centerX - 11.w, centerY - 20.h)
      ..quadraticBezierTo(centerX - 12.w, centerY - 10.h, centerX - 10.w - ghutraFlow, centerY + 6.h) // Inner left
      ..lineTo(centerX - 16.w - ghutraFlow, centerY + 6.h)
      ..quadraticBezierTo(centerX - 18.w - ghutraFlow, centerY - 5.h, centerX - 13.w, centerY - 22.h) // Left drape
      ..close();

    canvas.drawPath(ghutraPath, ghutraPaint);

    // Ghutra Red Checkered Pattern (simplified as diagonal dashed lines)
    final patternPaint = Paint()
      ..color = const Color(0xFFD32F2F).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.w;
    
    canvas.save();
    canvas.clipPath(ghutraPath);
    for (int i = -40; i < 40; i += 4) {
      canvas.drawLine(
          Offset(centerX - 30.w, centerY - 40.h + i.toDouble() * 3),
          Offset(centerX + 30.w, centerY - 10.h + i.toDouble() * 3),
          patternPaint);
      canvas.drawLine(
          Offset(centerX + 30.w, centerY - 40.h + i.toDouble() * 3),
          Offset(centerX - 30.w, centerY - 10.h + i.toDouble() * 3),
          patternPaint);
    }
    canvas.restore();

    // Agal (Black headband rings)
    final agalPath = Path()
      ..moveTo(centerX - 11.w, centerY - 28.h)
      ..quadraticBezierTo(centerX, centerY - 25.h, centerX + 11.w, centerY - 28.h);
    canvas.drawPath(agalPath, agalPaint);

    final agalPath2 = Path()
      ..moveTo(centerX - 10.w, centerY - 31.h)
      ..quadraticBezierTo(centerX, centerY - 28.h, centerX + 10.w, centerY - 31.h);
    canvas.drawPath(agalPath2, agalPaint);

    canvas.restore();
  }

  @override
  bool shouldRepaint(_CharacterPainter oldDelegate) {
    return oldDelegate.walkCycle != walkCycle;
  }
}
