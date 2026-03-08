import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/auth/presentation/sign_up/view/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:easy_localization/easy_localization.dart';

class SignUpPrompt extends StatelessWidget {
  const SignUpPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('dont_have_account'.tr(), style: AppTextStyles.bodyMedium),
            TextButton(
              onPressed: () {
                context.push(const SignUpScreen());
              },
              child: Text(
                'sign_up'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 800.ms, duration: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }
}
