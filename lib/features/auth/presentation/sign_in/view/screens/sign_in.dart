import 'package:arabic/core/helpers/spacing.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/sign_in_form.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/sign_in_logo.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/widgets/sign_up_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:easy_localization/easy_localization.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                // Logo Icon
                SizedBox(height: 32.h),
                SignInLogo(),
                // Welcome Text
                Text(
                      'welcome_back'.tr(),
                      style: AppTextStyles.displayLarge.copyWith(
                        fontSize: 28.sp,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 200.ms, duration: 400.ms)
                    .slideY(begin: -0.3, end: 0),

                verticalSpace(8),

                Text(
                      'sign_in_subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    )
                    .animate()
                    .fadeIn(delay: 300.ms, duration: 400.ms)
                    .slideY(begin: -0.3, end: 0),

                verticalSpace(32),

                // Login Form
                SignInForm(),

                verticalSpace(32),

                // Sign Up Prompt
                SignUpPrompt(),

                verticalSpace(24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
