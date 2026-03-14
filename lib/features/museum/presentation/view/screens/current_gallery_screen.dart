import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_state.dart';
import 'package:arabic/features/museum/presentation/view/widgets/museum_gallery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'place_tour_screen.dart';

class CurrentGalleryScreen extends StatefulWidget {
  const CurrentGalleryScreen({super.key});

  @override
  State<CurrentGalleryScreen> createState() => _CurrentGalleryScreenState();
}

class _CurrentGalleryScreenState extends State<CurrentGalleryScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: EdgeInsets.all(8.w),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withValues(alpha: 0.1),
                child: BackButton(color: AppColors.accentGold),
              ),
            ),
          ),
        ),
        title: Text(
          'museum_gallery_title'.tr(),
          style: AppTextStyles.h2.copyWith(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome, color: AppColors.accentGold),
            onPressed: () {}, // Add AI generator logic later
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: BlocListener<MuseumCubit, MuseumState>(
        listener: (context, state) async {
          if (state is MuseumError) {
            if (!await NetworkChecker.hasConnection()) {
              if (context.mounted) {
                NetworkChecker.showNoNetworkDialog(context);
              }
            }
          }
        },
        child: Stack(
          children: [
            // 3D Background
            const Background3D(),

            // PageView with 3D Effect
            BlocBuilder<MuseumCubit, MuseumState>(
              builder: (context, state) {
                if (state is MuseumLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.accentGold),
                  );
                }

                if (state is MuseumLoaded) {
                  return Column(
                    children: [
                      SizedBox(height: 120.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'select_location'.tr(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accentGold,
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              'walk_through_history'.tr(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn().slideX(),

                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: state.places.length,
                          itemBuilder: (context, index) {
                            final place = state.places[index];

                            // Calculate 3D transformation
                            double relativePosition = index - _currentPage;
                            double scale = (1 - (relativePosition.abs() * 0.15))
                                .clamp(0.0, 1.0);
                            double rotation = (relativePosition * 0.3).clamp(
                              -1.0,
                              1.0,
                            );
                            double opacity = (1 - (relativePosition.abs() * 0.5))
                                .clamp(0.0, 1.0);

                            return Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001) // Perspective
                                ..rotateY(rotation)
                                ..multiply(
                                  Matrix4.diagonal3Values(scale, scale, 1.0),
                                ),
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: opacity,
                                child: MuseumGalleryCard(
                                  place: place,
                                  onTap: () {
                                    context.read<MuseumCubit>().selectPlace(
                                      place,
                                    );
                                    context.push(const PlaceTourScreen());
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Page Indicator
                      Padding(
                        padding: EdgeInsets.only(bottom: 60.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            state.places.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 6,
                              width: (index == _currentPage.round()) ? 24 : 8,
                              decoration: BoxDecoration(
                                color: (index == _currentPage.round())
                                    ? AppColors.accentGold
                                    : AppColors.accentGold.withValues(
                                      alpha: 0.3,
                                    ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }

                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }
}
