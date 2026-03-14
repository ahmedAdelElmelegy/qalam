import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/helpers/spacing.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/view/screens/ai_generated_gallery_screen.dart';
import 'package:arabic/features/museum/presentation/view/screens/current_gallery_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:ui';

class VirtualGalleryScreen extends StatelessWidget {
  const VirtualGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryNavy,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('virtual_gallery'.tr()),
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
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Stack(
              children: [
                // 3D Background for premium feel
                const Background3D(),

                // Content Overlay
                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        // Animated Header
                        Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                color: AppColors.accentGold.withValues(
                                  alpha: 0.1,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.accentGold.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                              child: Icon(
                                Icons.grid_view_rounded,
                                size: 40.w,
                                color: AppColors.accentGold,
                              ),
                            ).animate().scale(
                              duration: 600.ms,
                              curve: Curves.easeOutBack,
                            ),

                            SizedBox(height: 16.h),

                            Text(
                              'choose_experience'.tr(),
                              style: AppTextStyles.h2.copyWith(
                                color: Colors.white,
                                fontSize: 28.sp,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn().slideY(begin: 0.2, end: 0),

                            SizedBox(height: 8.h),
                            Text(
                              'choose_experience_subtitle'.tr(),
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ).animate().fadeIn(delay: 200.ms),
                          ],
                        ),

                        SizedBox(height: 50.h),

                        // Option 1: Current Gallery - Classic/Elegant Theme
                        _buildPremiumCard(
                          context,
                          title: 'current_gallery_title'.tr(),
                          description:
                              'current_gallery_desc'.tr(),
                          icon: Icons.museum_rounded,
                          color: const Color(0xFFD4AF37), // Classic Gold
                          accentColor: const Color(0xFF8B4513), // Saddle Brown
                          onTap: () =>
                              context.push(const CurrentGalleryScreen()),
                          delay: 400,
                        ),

                        SizedBox(height: 24.h),

                        // Option 2: AI Generated Gallery - Futuristic Theme
                        _buildPremiumCard(
                          context,
                          title: 'ai_gallery_title'.tr(),
                          description:
                              'ai_gallery_desc'.tr(),
                          icon: Icons.auto_awesome_rounded,
                          color: const Color(0xFF00FFFF), // Cyan/Neon
                          accentColor: const Color(0xFF2E1065), // Deep Purple
                          onTap: () =>
                              context.push(const AiGeneratedGalleryScreen()),
                          delay: 600,
                          isBeta: true,
                        ),
                        verticalSpace(24),
                      ],
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

  Widget _buildPremiumCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required Color accentColor,
    required VoidCallback onTap,
    int delay = 0,
    bool isBeta = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 150.h,
            decoration: BoxDecoration(
              color: AppColors.primaryNavy.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: color.withValues(alpha: 0.3),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
                BoxShadow(
                  color: color.withValues(alpha: 0.1),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Stack(
              children: [
                // Abstract Background Pattern
                Positioned(
                  right: -50,
                  top: -50,
                  child: Container(
                    width: 200.w,
                    height: 200.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          color.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(24.w),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              color.withValues(alpha: 0.2),
                              color.withValues(alpha: 0.1),
                            ],
                          ),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: color.withValues(alpha: 0.5),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withValues(alpha: 0.2),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: color, size: 32.w),
                      ),

                      SizedBox(width: 20.w),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    title,
                                    style: AppTextStyles.h3.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isBeta) ...[
                                  SizedBox(width: 8.w),
                                  Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8.w,
                                          vertical: 4.h,
                                        ),
                                        decoration: BoxDecoration(
                                          color: color,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withValues(
                                                alpha: 0.4,
                                              ),
                                              blurRadius: 8,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          'beta_label'.tr(),
                                          style: AppTextStyles.bodySmall.copyWith(
                                            color: Colors
                                                .black, // Dark text on bright color
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10.sp,
                                          ),
                                        ),
                                      )
                                      .animate(
                                        onPlay: (c) => c.repeat(reverse: true),
                                      )
                                      .scale(
                                        begin: const Offset(1, 1),
                                        end: const Offset(1.1, 1.1),
                                      ),
                                ],
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              description,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white70,
                                height: 1.4,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),

                      // Arrow
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: color.withValues(alpha: 0.8),
                          size: 14.w,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(delay: delay.ms).slideX(begin: 0.1, end: 0),
    );
  }
}
