import 'dart:ui';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/circular_progress.dart';
import 'package:arabic/features/home/data/model/progress_model.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class HomeProgressCard extends StatelessWidget {
  final int userId;
  const HomeProgressCard({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeProgressCubit, HomeProgressState>(
      builder: (context, state) {
        if (state is HomeProgressLoading) {
          return _buildLoadingCard();
        }

        if (state is HomeProgressFailure) {
          return SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextButton.icon(
                      onPressed: () =>
                          context.read<HomeProgressCubit>().getProgress(userId),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: Text(
                        'retry'.tr(),
                        style: const TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.redAccent.withValues(
                          alpha: 0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final progressData = state is HomeProgressSuccess
            ? state.progress
            : const ProgressData(
                percentage: 0.0,
                completedLessonsCount: 0,
                totalXp: 0,
                activeDays: 0,
                lastSync: '',
              );

        return SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child:
                ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withValues(alpha: 0.15),
                                Colors.white.withValues(alpha: 0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.2),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.1,
                                ),
                                blurRadius: 30,
                                spreadRadius: 5,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Circular Progress with 3D effect
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.accentGold.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: AnimatedCircularProgress(
                                  progress: progressData.percentage / 100,
                                  size: 100.w,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.1,
                                  ),
                                  progressColor: AppColors.accentGold,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${(progressData.percentage / 10).toStringAsFixed(2)}%',
                                        style: AppTextStyles.h2.copyWith(
                                          fontSize: 24.sp,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.accentGold,
                                          shadows: [
                                            Shadow(
                                              color: AppColors.accentGold
                                                  .withValues(alpha: 0.5),
                                              blurRadius: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text(
                                        'complete'.tr(),
                                        style: AppTextStyles.bodySmall.copyWith(
                                          fontSize: 10.sp,
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(width: 24.w),

                              // Stats Grid
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'your_progress'.tr(),
                                      style: AppTextStyles.h3.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    Row(
                                      children: [
                                        _buildCompactStat(
                                          progressData.activeDays.toString(),
                                          'day_streak'.tr(),
                                          Icons.local_fire_department_rounded,
                                          const Color(0xFFFF6B6B),
                                        ),
                                        SizedBox(width: 12.w),
                                        _buildCompactStat(
                                          progressData.completedLessonsCount
                                              .toString(),
                                          'lessons'.tr(),
                                          Icons.book_rounded,
                                          AppColors.accentGold,
                                        ),
                                        SizedBox(width: 12.w),
                                        _buildCompactStat(
                                          progressData.totalXp.toString(),
                                          'xp'.tr(),
                                          Icons.star_rounded,

                                          const Color(0xFFFFD700),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 600.ms)
                    .slideY(begin: 0.3, end: 0, curve: Curves.easeOutCubic)
                    .scale(
                      begin: const Offset(0.9, 0.9),
                      curve: Curves.easeOutBack,
                    ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingCard() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Shimmer.fromColors(
          baseColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.2),
          child: Container(
            height: 160.h,
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                Container(
                  width: 100.w,
                  height: 100.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120.w,
                        height: 20.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: List.generate(
                          3,
                          (index) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: index < 2 ? 12.w : 0,
                              ),
                              child: Container(
                                height: 60.h,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompactStat(
    String value,
    String label,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.w),
            SizedBox(height: 6.h),
            FittedBox(
              child: Text(
                value,
                style: AppTextStyles.h4.copyWith(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: 2.h),
            FittedBox(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 9.sp,
                  height: 1.2,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
