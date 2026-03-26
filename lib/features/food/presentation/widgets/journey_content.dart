import 'dart:ui' as ui;

import 'package:arabic/features/food/presentation/cubit/food_state.dart';
import 'package:arabic/features/food/presentation/widgets/food_avatar.dart';
import 'package:arabic/features/food/presentation/widgets/food_island.dart';
import 'package:arabic/features/food/presentation/widgets/food_journey_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FoodJourneyContent extends StatelessWidget {
  final FoodState state;
  final AnimationController avatarController;
  final String lang;

  const FoodJourneyContent({
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
            height: (350 * state.foodItems.length).h.clamp(1600.h, 5000.h),
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
                      painter: FoodJourneyPainter(),
                    ),
                    ...state.foodItems.asMap().entries.map((entry) {
                      return FoodIsland(
                        index: entry.key,
                        food: entry.value,
                        total: state.foodItems.length,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        selectedFoodIndex: state.selectedFoodIndex,
                        lang: lang,
                        avatarController: avatarController,
                      );
                    }),
                    FoodAvatar(
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

  ui.Path _buildPath(double width, double height) {
    final centerX = width * 0.5;
    width * 0.25;

    final path = ui.Path();
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
