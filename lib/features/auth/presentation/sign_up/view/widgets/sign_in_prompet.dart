import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:easy_localization/easy_localization.dart';

class SignInPrompt extends StatelessWidget {
  const SignInPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('already_have_account'.tr(), style: AppTextStyles.bodyMedium),
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: Text(
                'sign_in'.tr(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: 1000.ms, duration: 400.ms)
        .slideY(begin: 0.3, end: 0);
  }
}
