import 'package:arabic/features/clothing/presentation/cubit/clothing_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'clothing_island.dart';
import 'clothing_journey_painter.dart';
import 'clothing_avatar.dart';

class ClothingJourneyContent extends StatelessWidget {
  final ClothingState state;
  final AnimationController avatarController;
  final String lang;

  const ClothingJourneyContent({
    super.key,
    required this.state,
    required this.avatarController,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Container(
            height: (350 * state.clothingItems.length).h.clamp(1600.h, 5000.h),
            padding: EdgeInsets.symmetric(vertical: 120.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final path = _buildPath(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: ClothingJourneyPainter(),
                    ),
                    ...state.clothingItems.asMap().entries.map((entry) {
                      return ClothingIsland(
                        index: entry.key,
                        clothing: entry.value,
                        total: state.clothingItems.length,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        selectedClothingIndex: state.selectedClothingIndex,
                        lang: lang,
                        avatarController: avatarController,
                      );
                    }),
                    ClothingAvatar(
                      avatarController: avatarController,
                      path: path,
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Path _buildPath(double width, double height) {
    final centerX = width * 0.5;

    final path = Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      width * 0.85,
      height * 0.2,
      width * 0.15,
      height * 0.3,
      width * 0.5,
      height * 0.45,
    );
    path.cubicTo(
      width * 0.85,
      height * 0.6,
      width * 0.15,
      height * 0.7,
      width * 0.5,
      height * 0.85,
    );
    path.lineTo(width * 0.5, height);
    return path;
  }
}
