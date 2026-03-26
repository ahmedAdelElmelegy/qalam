import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FloatingOrbs extends StatelessWidget {
  final double scrollOffset;

  const FloatingOrbs({super.key, required this.scrollOffset});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: List.generate(3, (index) {
        final positions = [
          {
            'top': 150.0,
            'left': 30.0,
            'size': 100.0,
            'color': const Color(0xFFD4AF37),
          },
          {
            'top': 400.0,
            'right': 40.0,
            'size': 90.0,
            'color': const Color(0xFF6366F1),
          },
          {
            'top': 650.0,
            'left': 50.0,
            'size': 95.0,
            'color': const Color(0xFF8B5CF6),
          },
        ];

        final pos = positions[index];
        final parallaxFactor = 0.3 + (index * 0.1);

        return Positioned(
          top: (pos['top'] as double) - (scrollOffset * parallaxFactor),
          left: pos.containsKey('left') ? pos['left'] as double : null,
          right: pos.containsKey('right') ? pos['right'] as double : null,
          child: IgnorePointer(
            child: Container(
              width: pos['size'] as double,
              height: pos['size'] as double,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    (pos['color'] as Color).withValues(alpha: 0.15),
                    (pos['color'] as Color).withValues(alpha: 0.0),
                  ],
                ),
              ),
            )
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.2, 1.2),
              duration: Duration(milliseconds: 3000 + (index * 500)),
              curve: Curves.easeInOut,
            ),
          ),
        );
      }),
    );
  }
}
