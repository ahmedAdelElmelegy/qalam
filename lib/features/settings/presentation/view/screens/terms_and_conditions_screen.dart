import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Dynamic Background Orbs
          _buildBackgroundOrb(
            top: -100,
            left: -50,
            color: AppColors.accentGold,
            size: 350,
            delay: 0,
            right: null,
          ),
          _buildBackgroundOrb(
            bottom: -150,
            right: -100,
            color: AppColors.primaryDeep,
            size: 400,
            delay: 400,
            top: null,
            left: null,
          ),
          _buildBackgroundOrb(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -80,
            color: AppColors.accentGold.withValues(alpha: 0.3),
            size: 200,
            delay: 800,
            right: null,
            bottom: null,
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                  child: Row(
                    children: [
                      BackButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(
                            AppColors.accentGold.withValues(alpha: 0.1),
                          ),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          padding: WidgetStatePropertyAll(
                            EdgeInsets.all(12.w),
                          ),
                        ),
                        color: AppColors.accentGold,
                        onPressed: () => context.pop(),
                      ).animate().fadeIn().slideX(begin: -0.2, end: 0),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Text(
                          'terms_and_conditions'.tr(),
                          style: AppTextStyles.h2.copyWith(
                            color: Colors.white,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.2, end: 0),
                      ),
                    ],
                  ),
                ),

                // Introduction Text
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                  child: Text(
                    'terms_intro'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white60,
                      height: 1.5,
                      fontSize: 14.sp,
                    ),
                    textAlign: TextAlign.center,
                  ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2, end: 0),
                ),

                SizedBox(height: 16.h),

                // Scrollable Content Layout
                Expanded(
                  child: ListView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 32.h),
                    children: [
                      _buildTCCard(
                        number: '01',
                        icon: Icons.check_circle_outline_rounded,
                        title: 'acceptance_terms'.tr(),
                        content: 'acceptance_terms_content'.tr(),
                        delay: 300,
                      ),
                      _buildTCCard(
                        number: '02',
                        icon: Icons.person_outline_rounded,
                        title: 'user_responsibilities'.tr(),
                        content: 'user_responsibilities_content'.tr(),
                        delay: 400,
                      ),
                      _buildTCCard(
                        number: '03',
                        icon: Icons.privacy_tip_outlined,
                        title: 'privacy_policy'.tr(),
                        content: 'privacy_policy_content'.tr(),
                        delay: 500,
                      ),
                      _buildTCCard(
                        number: '04',
                        icon: Icons.copyright_rounded,
                        title: 'intellectual_property'.tr(),
                        content: 'intellectual_property_content'.tr(),
                        delay: 600,
                      ),
                      _buildTCCard(
                        number: '05',
                        icon: Icons.gavel_rounded,
                        title: 'limit_liability'.tr(),
                        content: 'limit_liability_content'.tr(),
                        delay: 700,
                      ),
                      SizedBox(height: 32.h),
                      _buildFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackgroundOrb({
    required double? top,
    required double? left,
    double? right,
    double? bottom,
    required Color color,
    required double size,
    required int delay,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.2),
                      blurRadius: size / 2,
                      spreadRadius: size / 4,
                    )
                  ]
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(delay: delay.ms, duration: 2.seconds)
              .scale()
              .moveY(begin: 0, end: 20, duration: 4.seconds, curve: Curves.easeInOutSine),
    );
  }

  Widget _buildTCCard({
    required String number,
    required IconData icon,
    required String title,
    required String content,
    required int delay,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: GlassContainer(
        padding: EdgeInsets.all(20.w),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.08),
          width: 1,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: AppColors.accentGold.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: AppColors.accentGold, size: 24.w),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'section_number'.tr(args: [number]),
                        style: AppTextStyles.overline.copyWith(
                          color: AppColors.accentGold.withValues(alpha: 0.8),
                          letterSpacing: 2,
                          fontSize: 10.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        title,
                        style: AppTextStyles.h4.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              content,
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.75),
                height: 1.6,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: delay.ms, duration: 500.ms).slideY(begin: 0.1, end: 0, curve: Curves.easeOutQuad),
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 40.w,
            height: 3,
            decoration: BoxDecoration(
              color: AppColors.accentGold.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'last_updated'.tr(
              args: [
                DateFormat('yyyy-MM-dd').format(DateTime.now()),
              ],
            ),
            style: AppTextStyles.overline.copyWith(
              color: Colors.white30,
              fontSize: 11.sp,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Qalam Arabic © ${DateTime.now().year}',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white24,
              fontSize: 12.sp,
            ),
          )
        ],
      ),
    ).animate().fadeIn(delay: 900.ms);
  }
}
