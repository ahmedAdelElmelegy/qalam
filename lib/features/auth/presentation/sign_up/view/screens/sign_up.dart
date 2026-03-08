import 'package:arabic/core/helpers/spacing.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/auth/presentation/sign_up/view/widgets/animation_avatar_with_custom_icon.dart';
import 'package:arabic/features/auth/presentation/sign_up/view/widgets/sign_in_prompet.dart';
import 'package:arabic/features/auth/presentation/sign_up/view/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:easy_localization/easy_localization.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryNavy,
              AppColors.primaryNavy.withValues(alpha: 0.9),
              Color.lerp(AppColors.primaryNavy, AppColors.accentGold, 0.05)!,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                verticalSpace(40),

                // Animated Avatar with Custom Icon
                AnimationAvatarWithCustomIcon(),
                verticalSpace(32),

                // Title
                Text(
                      'create_account'.tr(),
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 32.sp,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: -0.3, end: 0),

                verticalSpace(8),

                Text(
                      'sign_up_subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: -0.3, end: 0),

                SizedBox(height: 32.h),

                // Registration Form
                SignUpForm(),

                verticalSpace(24),

                // Sign In Prompt
                const SignInPrompt(),

                verticalSpace(40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
