import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/traditions/cubit/tradition_state.dart';
import 'traditions_island.dart';
import 'traditions_journey_painter.dart';
import 'traditions_avatar.dart';

class TraditionsJourneyContent extends StatelessWidget {
  final TraditionState state;
  final AnimationController avatarController;
  final String lang;

  const TraditionsJourneyContent({
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
            height: (350 * state.traditions.length).h.clamp(1600.h, 5000.h),
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
                      painter: TraditionsJourneyPainter(),
                    ),
                    ...state.traditions.asMap().entries.map((entry) {
                      return TraditionsIsland(
                        index: entry.key,
                        tradition: entry.value,
                        total: state.traditions.length,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        selectedTraditionIndex: state.selectedTraditionIndex,
                        lang: lang,
                        avatarController: avatarController,
                      );
                    }),
                    TraditionsAvatar(
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

    final path = ui.Path();
    path.moveTo(centerX, 0);
    // Enhanced S-curve path
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
