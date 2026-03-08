import 'dart:ui';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/network/data_source/remote/exception/api_error_handeler.dart';
import 'package:arabic/core/network/data_source/remote/exception/app_exeptions.dart';
import 'package:arabic/features/curriculum/presentation/manager/level/level_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_card.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_background.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/level_shapes.dart';

class LevelSelectorScreen extends StatefulWidget {
  const LevelSelectorScreen({super.key});

  @override
  State<LevelSelectorScreen> createState() => _LevelSelectorScreenState();
}

class _LevelSelectorScreenState extends State<LevelSelectorScreen> {
  @override
  void initState() {
    super.initState();
    // Only fetch if needed (Cubit handles the logic)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LevelCubit>().getLevels(context.locale.languageCode);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Re-trigger fetch when locale changes
    context.read<LevelCubit>().getLevels(context.locale.languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Rich background
          const Positioned.fill(child: LevelBackground()),
          // Floating geometric decorations
          const Positioned.fill(child: LevelShapes()),
          // Content
          SafeArea(
            child: BlocBuilder<LevelCubit, LevelState>(
              builder: (context, state) {
                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 220.h,
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      leadingWidth: 64.w,
                      leading: Padding(
                        padding: EdgeInsets.only(left: 20.w),
                        child: Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              width: 38.w,
                              height: 38.w,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.08),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.15),
                                ),
                              ),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: false,
                        titlePadding: EdgeInsets.only(left: 68.w, bottom: 16.h),
                        title: LayoutBuilder(
                          builder: (context, constraints) {
                            final double opacity =
                                constraints.maxHeight <=
                                    kToolbarHeight +
                                        MediaQuery.of(context).padding.top +
                                        15
                                ? 1.0
                                : 0.0;
                            return Opacity(
                              opacity: opacity,
                              child: Text(
                                'choose_level'.tr(),
                                style: AppTextStyles.h4.copyWith(
                                  color: Colors.white,
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            );
                          },
                        ),
                        background: Stack(
                          children: [
                            // Glass effect for the app bar when pinned
                            Positioned.fill(
                              child: ClipRect(
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 10,
                                    sigmaY: 10,
                                  ),
                                  child: Container(color: Colors.transparent),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(24.w, 60.h, 24.w, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 30.h),
                                  Text(
                                    'choose_level'.tr(),
                                    style: AppTextStyles.h1.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 28.sp,
                                      letterSpacing: -1.2,
                                      height: 1.1,
                                    ),
                                  ).animate().fadeIn().slideY(
                                    begin: 0.3,
                                    end: 0,
                                    curve: Curves.easeOutQuart,
                                  ),
                                  SizedBox(height: 6.h),
                                  Text(
                                    'level_subtitle'.tr(),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.45,
                                      ),
                                      fontSize: 14.sp,
                                    ),
                                  ).animate().fadeIn(delay: 150.ms),
                                  SizedBox(height: 12.h),
                                  Container(
                                        height: 3.h,
                                        width: 40.w,
                                        decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFFD4AF37),
                                              Color(0xFFFFE066),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            2,
                                          ),
                                        ),
                                      )
                                      .animate()
                                      .fadeIn(delay: 250.ms)
                                      .scaleX(
                                        begin: 0,
                                        alignment: Alignment.centerLeft,
                                      ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state is LevelLoading)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const CircularProgressIndicator(
                                color: Color(0xFFD4AF37),
                                strokeWidth: 2,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                'Loading...',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (state is LevelFailed)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(32.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(24.w),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    state.exception is NetworkException
                                        ? Icons.wifi_off_rounded
                                        : Icons.error_outline_rounded,
                                    color: Colors.redAccent.withValues(
                                      alpha: 0.8,
                                    ),
                                    size: 48.w,
                                  ),
                                ).animate().shake(duration: 500.ms),
                                SizedBox(height: 24.h),
                                Text(
                                  ApiErrorHandler.getUserMessage(
                                    state.exception,
                                  ),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.h4.copyWith(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  'error_tap_to_retry'.tr(),
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                SizedBox(height: 32.h),
                                GestureDetector(
                                  onTap: () => context
                                      .read<LevelCubit>()
                                      .getLevels(context.locale.languageCode),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.w,
                                      vertical: 12.h,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFD4AF37),
                                          const Color(
                                            0xFFD4AF37,
                                          ).withValues(alpha: 0.7),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFFD4AF37,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      'retry'.tr(),
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else if (state is LevelSucess)
                      SliverPadding(
                        padding: EdgeInsets.fromLTRB(24.w, 10.h, 24.w, 60.h),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                mainAxisSpacing: 20.h,
                                crossAxisSpacing: 20.w,
                                childAspectRatio: 0.88,
                              ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final levelModel = context
                                  .read<LevelCubit>()
                                  .levelList[index];
                              return LevelCard(level: levelModel, index: index);
                            },
                            childCount: context
                                .read<LevelCubit>()
                                .levelList
                                .length,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
