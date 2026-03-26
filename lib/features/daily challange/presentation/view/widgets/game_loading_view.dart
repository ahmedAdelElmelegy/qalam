import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameLoadingView extends StatelessWidget {
  const GameLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomLoadingWidget(),
          SizedBox(height: 24.h),
          Text(
            'generating_challenges'.tr(context: context),
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white70,
            ),
          )
              .animate()
              .fadeIn(duration: 500.ms)
              .shimmer(color: AppColors.accentGold, duration: 2000.ms),
        ],
      ),
    );
  }
}
