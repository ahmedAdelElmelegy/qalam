import 'dart:ui' as ui;

import 'package:arabic/features/city/presentation/cubit/city_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'city_island.dart';
import 'city_journey_painter.dart';
import 'city_avatar.dart';

class CityJourneyContent extends StatelessWidget {
  final CityState state;
  final AnimationController avatarController;
  final String lang;

  const CityJourneyContent({
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
            height: (350 * state.cities.length).h.clamp(1600.h, 6000.h),
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
                      painter: CityJourneyPainter(),
                    ),
                    ...state.cities.asMap().entries.map((entry) {
                      return CityIsland(
                        index: entry.key,
                        city: entry.value,
                        total: state.cities.length,
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        selectedCityIndex: state.selectedCityIndex,
                        lang: lang,
                        avatarController: avatarController,
                      );
                    }),
                    CityAvatar(
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
