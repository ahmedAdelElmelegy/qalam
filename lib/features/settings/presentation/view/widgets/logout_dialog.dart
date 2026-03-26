import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/screens/sign_in.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: GlassContainer(
            width: 0.85.sw,
            padding: EdgeInsets.all(24.w),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: const Color(0xFFE94560),
                    size: 32.w,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'logout_title'.tr(),
                  style: AppTextStyles.h3.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'logout_confirmation'.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 32.h),
                PremiumButton(
                  text: 'logout'.tr(),
                  isGold: false,
                  isDanger: true,
                  onPressed: () async {
                    context.read<HomeProgressCubit>().clearProgress();
                    context.read<GetProfileCubit>().clearProfile();
                    await LocalStorage.clearAll();
                    if (context.mounted) {
                      context.pushAndRemoveUntil(const SignInScreen());
                    }
                  },
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'cancel'.tr(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
