import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/settings/presentation/view/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeHeaderSection extends StatefulWidget {
  final double scrollOffset;

  const HomeHeaderSection({super.key, required this.scrollOffset});

  @override
  State<HomeHeaderSection> createState() => _HomeHeaderSectionState();
}

class _HomeHeaderSectionState extends State<HomeHeaderSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate parallax and 3D effects based on scroll
    final heroParallax = -widget.scrollOffset * 0.2;
    final heroScale = 1.0 - (widget.scrollOffset * 0.0005).clamp(0.0, 0.3);
    final heroOpacity = (1.0 - (widget.scrollOffset * 0.002)).clamp(0.0, 1.0);

    return SliverToBoxAdapter(
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..multiply(Matrix4.translationValues(0.0, heroParallax, 0.0))
          ..multiply(Matrix4.diagonal3Values(heroScale, heroScale, 1.0)),
        alignment: Alignment.center,
        child: Opacity(
          opacity: heroOpacity,
          child: Column(
            children: [
              SizedBox(height: 20.h),

              // Greeting Section with Settings
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Expanded(
                      child: BlocBuilder<GetProfileCubit, GetProfileState>(
                        builder: (context, state) {
                          String namePlaceholder = 'there!';
                          if (state is GetProfileSuccess) {
                            namePlaceholder = state.profile.fullName;
                          }

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                    'greeting_name'.tr(
                                      context: context,
                                      args: [namePlaceholder],
                                    ),
                                    style: AppTextStyles.displayMedium.copyWith(
                                      fontSize: 21.sp,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          offset: const Offset(0, 2),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 200.ms)
                                  .slideX(begin: -0.2, end: 0),
                              SizedBox(height: 6.h),
                              Text(
                                    'ready_to_continue'.tr(context: context),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.8,
                                      ),
                                      fontSize: 14.sp,
                                    ),
                                  )
                                  .animate()
                                  .fadeIn(delay: 300.ms)
                                  .slideX(begin: -0.2, end: 0),
                            ],
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.accentGold.withValues(alpha: 0.2),
                            AppColors.accentGold.withValues(alpha: 0.1),
                          ],
                        ),
                        border: Border.all(
                          color: AppColors.accentGold.withValues(alpha: 0.3),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accentGold.withValues(alpha: 0.2),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () => context.push(const SettingsScreen()),
                        icon: Icon(
                          Icons.settings_rounded,
                          color: AppColors.accentGold,
                          size: 24.w,
                        ),
                      ),
                    ).animate().fadeIn(delay: 400.ms).scale(),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
