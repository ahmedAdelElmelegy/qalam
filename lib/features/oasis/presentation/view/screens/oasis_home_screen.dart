import 'package:arabic/features/oasis/presentation/view/widgets/oasis_background.dart';
import 'package:arabic/features/oasis/presentation/view/widgets/oasis_feature.dart';
import 'package:arabic/features/oasis/presentation/view/widgets/oasis_header.dart';
import 'package:arabic/features/oasis/presentation/view/widgets/oasis_hero_card.dart';
import 'package:arabic/features/oasis/presentation/view/widgets/oasis_mini_card.dart';
import 'package:arabic/features/oasis/presentation/view/widgets/oasis_shapes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OasisHomeScreen extends StatelessWidget {
  const OasisHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      OasisFeature(
        title: 'recordings'.tr(),
        subtitle: 'my_voice_log'.tr(),
        icon: Icons.mic_rounded,
        color: const Color(0xFFF59E0B),
        accentColor: const Color(0xFFFCD34D),
        description: 'review_practice'.tr(),
        routeId: 'recordings',
      ),
      OasisFeature(
        title: 'dialects'.tr(),
        subtitle: 'choose_dialect'.tr(),
        icon: Icons.language_rounded,
        color: const Color(0xFF06B6D4),
        accentColor: const Color(0xFF67E8F9),
        description: 'explore_arabic'.tr(),
        routeId: 'dialects',
      ),
      OasisFeature(
        title: 'settings'.tr(),
        subtitle: 'app_settings'.tr(),
        icon: Icons.settings_suggest_rounded,
        color: const Color(0xFF8B5CF6),
        accentColor: const Color(0xFFC4B5FD),
        description: 'personalize_app'.tr(),
        routeId: 'settings',
      ),
      OasisFeature(
        title: 'help'.tr(),
        subtitle: 'support_center'.tr(),
        icon: Icons.help_center_rounded,
        color: const Color(0xFF10B981),
        accentColor: const Color(0xFF6EE7B7),
        description: 'get_support'.tr(),
        routeId: 'help',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          // Rich layered background
          const Positioned.fill(child: OasisBackground()),
          // Decorative geometric shapes
          const Positioned.fill(child: OasisShapes()),
          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: OasisHeader()),
                // Hero section - first 2 as large horizontal cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                    child: Column(
                      children: [
                        OasisHeroCard(feature: features[0], index: 0),
                        SizedBox(height: 16.h),
                        OasisHeroCard(feature: features[1], index: 1),
                      ],
                    ),
                  ),
                ),
                // Bottom 2 as smaller grid
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 60.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => OasisMiniCard(
                        feature: features[index + 2],
                        index: index,
                      ),
                      childCount: 2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
