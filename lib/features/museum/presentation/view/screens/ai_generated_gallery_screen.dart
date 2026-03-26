import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_cubit.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/museum_state.dart';
import 'package:arabic/features/museum/presentation/view/screens/place_details_screen.dart';
import 'package:arabic/features/museum/presentation/view/widgets/museum_error_dialog.dart';
import 'package:arabic/features/museum/presentation/view/widgets/museum_gallery_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../widgets/add_custom_place_dialog.dart';
import '../widgets/ai_gallery_loading_card.dart';

class AiGeneratedGalleryScreen extends StatefulWidget {
  const AiGeneratedGalleryScreen({super.key});

  @override
  State<AiGeneratedGalleryScreen> createState() =>
      _AiGeneratedGalleryScreenState();
}

class _AiGeneratedGalleryScreenState extends State<AiGeneratedGalleryScreen> {
  late PageController _pageController;
  double _currentPage = 0.0;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.82);

    _pageController.addListener(_onScroll);

    // Initial load: fetch from backend API first
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MuseumCubit>().initGallery();
    });

    LocalStorage.getLanguage().then((value) {
      if (!mounted) return;
      setState(() => lang = value ?? 'en');
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newLocale = context.locale;
    // Check if the locale has changed since last time
    if (lang != newLocale.languageCode) {
      lang = newLocale.languageCode;
      // Refresh the gallery to fetch data for the new language
      context.read<MuseumCubit>().refreshGallery();
    }
  }

  void _onScroll() {
    if (!mounted) return;
    setState(() {
      _currentPage = _pageController.page ?? 0.0;
    });

    final cubit = context.read<MuseumCubit>();
    final state = cubit.state;

    // Trigger load at 70% of the list
    if (state is MuseumLoaded &&
        !state.isAiLoading &&
        !state.isLoadingFromApi &&
        state.aiPlaces.isNotEmpty) {
      final maxIndex = state.aiPlaces.length - 1;
      final threshold = maxIndex * 0.7;
      if (_currentPage >= threshold) {
        cubit.loadMorePlaces();
      }
    }
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
      // app bar
      appBar: AppBar(
        title: Text('ai_gallery_screen_title'.tr()),
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
                child: const BackButton(color: AppColors.accentGold),
              ),
            ),
          ),
        ),
        actions: [
          BlocBuilder<MuseumCubit, MuseumState>(
            builder: (context, state) {
              // for loading
              if (state is MuseumLoaded && state.isAiLoading) {
                return Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.accentGold,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // 3D Background
          const Background3D(),

          BlocConsumer<MuseumCubit, MuseumState>(
            listener: (context, state) async {
              if (state is MuseumError) {
                final hasConnection = await NetworkChecker.hasConnection();
                if (!context.mounted) return;

                if (!hasConnection) {
                  NetworkChecker.showNoNetworkDialog(context);
                } else {
                  MuseumErrorDialog.show(
                    context,
                    state.message,
                    onRetry: () {
                      context.read<MuseumCubit>().loadMuseumData();
                    },
                  );
                }
              }

              if (state is MuseumLoaded) {
                // Handle API or AI generation errors
                if (state.apiError != null || state.aiError != null) {
                  // If we have data, show a snackbar. If not, the builder handles it.
                  if (state.aiPlaces.isNotEmpty) {
                    final hasConnection = await NetworkChecker.hasConnection();
                    if (!context.mounted) return;

                    if (!hasConnection) {
                      NetworkChecker.showNoNetworkDialog(context);
                    } else {
                      AppSnakeBar.showErrorMessage(
                        context,
                        state.apiError ?? state.aiError!,
                      );
                    }
                  }
                }

                // Initial load bridge
                if (state.aiPlaces.isEmpty &&
                    !state.isLoadingFromApi &&
                    !state.isAiLoading &&
                    state.apiError == null &&
                    state.aiError == null) {
                  context.read<MuseumCubit>().initGallery();
                }
              }
            },
            builder: (context, state) {
              if (state is! MuseumLoaded) {
                return const Center(
                  child: CircularProgressIndicator(color: AppColors.accentGold),
                );
              }

              if (state.aiPlaces.isEmpty) {
                // Initial loading or empty state
                if (state.isAiLoading || state.isLoadingFromApi) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          color: AppColors.accentGold,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Loading...'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ).animate().fadeIn(),
                      ],
                    ),
                  );
                } else if (state.apiError != null || state.aiError != null) {
                  // Error state when list is empty
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            size: 60.w,
                            color: AppColors.error.withValues(alpha: 0.6),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.apiError ?? state.aiError!,
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (state.apiError != null) {
                                context.read<MuseumCubit>().initGallery();
                              } else {
                                context.read<MuseumCubit>().loadMorePlaces();
                              }
                            },
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.black,
                            ),
                            label: Text('try_again'.tr()),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.accentGold,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  // Empty state with retry
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.museum_outlined,
                          size: 60.w,
                          color: Colors.white30,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'no_exhibits_found'.tr(),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              context.read<MuseumCubit>().initGallery(),
                          child: const Text(
                            'Try Again',
                            style: TextStyle(color: AppColors.accentGold),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }

              final bool showLoadingCard =
                  state.isAiLoading || state.isLoadingFromApi;

              return Column(
                children: [
                  SizedBox(height: 120.h),

                  // Dynamic Header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: const Color(0xFF00FFFF),
                              size: 16.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'ai_generated_label'.tr(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: const Color(0xFF00FFFF),
                                letterSpacing: 2,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'endless_exploration'.tr(),
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
                      itemCount:
                          state.aiPlaces.length + (showLoadingCard ? 1 : 0),
                      itemBuilder: (context, index) {
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

                        // If it's the loading card
                        if (index == state.aiPlaces.length) {
                          return RepaintBoundary(
                            child: Transform(
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(rotation)
                                ..multiply(
                                  Matrix4.diagonal3Values(scale, scale, 1.0),
                                ),
                              alignment: Alignment.center,
                              child: Opacity(
                                opacity: opacity,
                                child: const AiGalleryLoadingCard(),
                              ),
                            ),
                          );
                        }

                        final place = state.aiPlaces[index];

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
                                context.read<MuseumCubit>().selectPlace(place);
                                context.push(PlaceDetailsScreen(place: place));
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Progress Indicator
                  if (state.aiPlaces.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(bottom: 60.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_currentPage.round() < state.aiPlaces.length) ...[
                            Text(
                              '${(_currentPage.round() + 1)} / ${state.aiPlaces.length}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white60,
                              ),
                            ),
                          ] else ...[
                            Text(
                              'curating_discovery'.tr(),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.accentGold,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: FloatingActionButton.extended(
          onPressed: () => AddCustomPlaceDialog.show(context),
          backgroundColor: AppColors.accentGold,
          icon: const Icon(Icons.add_location_alt, color: Colors.black),
          label: Text(
            'add_place'.tr(),
            style: AppTextStyles.buttonMedium.copyWith(color: Colors.black),
          ),
        ),
      ),
    );
  }
}
