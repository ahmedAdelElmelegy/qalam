import 'package:arabic/features/museum/data/models/culture_zone_model.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/culture_path_avatar.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/culture_zone_card.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/journey_path_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CultureIslandJourneyContent extends StatelessWidget {
  final List<CultureZone> zones;
  final int activeZoneIndex;
  final AnimationController avatarController;

  const CultureIslandJourneyContent({
    super.key,
    required this.zones,
    required this.activeZoneIndex,
    required this.avatarController,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Container(
            height: 2000.h,
            padding: EdgeInsets.symmetric(vertical: 120.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // 1. Draw Path
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: JourneyPathPainter(),
                    ),

                    // 2. Zone Cards
                    ...zones.asMap().entries.map((entry) {
                      final index = entry.key;
                      final zone = entry.value;
                      return CultureZoneCard(
                        index: index,
                        zone: zone,
                        total: zones.length,
                        size: Size(constraints.maxWidth, constraints.maxHeight),
                        isActive: activeZoneIndex == index,
                      );
                    }),

                    // 3. Walking Avatar
                    CulturePathAvatar(
                      controller: avatarController,
                      size: Size(constraints.maxWidth, constraints.maxHeight),
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
}
