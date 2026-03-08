import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/colors.dart';
import '../widgets/museum_header_section.dart';
import '../widgets/museum_selection_card.dart';
import 'virtual_gallery_screen.dart';
import 'culture_island_screen.dart';

import 'package:easy_localization/easy_localization.dart';

class MuseumHomeScreen extends StatelessWidget {
  const MuseumHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('museum_title'.tr()),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.accentGold),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                // 3D Background
                const Background3D(),

                // Content
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Builder(
                      builder: (context) {
                        final isWide = MediaQuery.sizeOf(context).width > 600;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),

                            // Header Section
                            const MuseumHeaderSection(),

                            SizedBox(height: 48.h),

                            // Selection Cards
                            if (isWide)
                              Row(
                                children: [
                                  Expanded(
                                    child: MuseumSelectionCard(
                                      title: 'virtual_gallery'.tr(),
                                      subtitle: 'virtual_gallery_subtitle'.tr(),
                                      icon: Icons.map_rounded,
                                      color: const Color(0xFF6366F1),
                                      route: const VirtualGalleryScreen(),
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                  Expanded(
                                    child: MuseumSelectionCard(
                                      title: 'culture_island'.tr(),
                                      subtitle: 'culture_island_subtitle'.tr(),
                                      icon: Icons.landscape_rounded,
                                      color: const Color(0xFFEC4899),
                                      route: const CultureIslandScreen(),
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              MuseumSelectionCard(
                                title: 'virtual_gallery'.tr(),
                                subtitle: 'virtual_gallery_subtitle'.tr(),
                                icon: Icons.map_rounded,
                                color: const Color(0xFF6366F1),
                                route: const VirtualGalleryScreen(),
                              ),
                              SizedBox(height: 20.h),
                              MuseumSelectionCard(
                                title: 'culture_island'.tr(),
                                subtitle: 'culture_island_subtitle'.tr(),
                                icon: Icons.landscape_rounded,
                                color: const Color(0xFFEC4899),
                                route: const CultureIslandScreen(),
                              ),
                            ],

                            SizedBox(height: 50.h),
                          ],
                        );
                      },
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
