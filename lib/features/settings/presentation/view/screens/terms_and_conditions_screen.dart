import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/profile_background_orb.dart';
import '../widgets/tc_card.dart';
import '../widgets/tc_footer.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Dynamic Background Orbs
          const ProfileBackgroundOrb(
            top: -100,
            left: -50,
            color: AppColors.accentGold,
            size: 350,
            delay: 0,
          ),
          const ProfileBackgroundOrb(
            bottom: -150,
            right: -100,
            color: AppColors.primaryDeep,
            size: 400,
            delay: 400,
          ),
          ProfileBackgroundOrb(
            top: MediaQuery.of(context).size.height * 0.4,
            left: -80,
            color: AppColors.accentGold.withValues(alpha: 0.3),
            size: 200,
            delay: 800,
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
                      TCCard(
                        number: '01',
                        icon: Icons.check_circle_outline_rounded,
                        title: 'acceptance_terms'.tr(),
                        content: 'acceptance_terms_content'.tr(),
                        delay: 300,
                      ),
                      TCCard(
                        number: '02',
                        icon: Icons.person_outline_rounded,
                        title: 'user_responsibilities'.tr(),
                        content: 'user_responsibilities_content'.tr(),
                        delay: 400,
                      ),
                      TCCard(
                        number: '03',
                        icon: Icons.privacy_tip_outlined,
                        title: 'privacy_policy'.tr(),
                        content: 'privacy_policy_content'.tr(),
                        delay: 500,
                      ),
                      TCCard(
                        number: '04',
                        icon: Icons.copyright_rounded,
                        title: 'intellectual_property'.tr(),
                        content: 'intellectual_property_content'.tr(),
                        delay: 600,
                      ),
                      TCCard(
                        number: '05',
                        icon: Icons.gavel_rounded,
                        title: 'limit_liability'.tr(),
                        content: 'limit_liability_content'.tr(),
                        delay: 700,
                      ),
                      SizedBox(height: 32.h),
                      const TCFooter(),
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
}
