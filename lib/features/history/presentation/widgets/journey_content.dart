import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/history/presentation/cubit/history_state.dart';
import 'history_island.dart';
import 'history_journey_painter.dart';
import 'history_avatar.dart';

class HistoryJourneyContent extends StatelessWidget {
  final HistoryState state;
  final AnimationController avatarController;
  final String lang;

  const HistoryJourneyContent({
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
            // Dynamic height based on number of periods to ensure they all fit
            height: (300 * state.periods.length).h.clamp(1600.h, 5000.h),
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
                      painter: HistoryJourneyPainter(),
                    ),
                    ...state.periods.asMap().entries.map((entry) {
                      return HistoryIsland(
                        index: entry.key,
                        period: entry.value,
                        total: state.periods.length,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        currentPeriod: state.currentPeriod,
                        lang: lang,
                        avatarController: avatarController,
                      );
                    }),
                    HistoryAvatar(
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
    // Narrower path to prevent items from bleeding off edges
    final centerX = width * 0.5;
    final curveX = width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      centerX + curveX,
      height * 0.2,
      centerX - curveX,
      height * 0.4,
      centerX,
      height * 0.5,
    );
    path.cubicTo(
      centerX + curveX,
      height * 0.6,
      centerX - curveX,
      height * 0.8,
      centerX,
      height * 1.0,
    );
    return path;
  }
}
