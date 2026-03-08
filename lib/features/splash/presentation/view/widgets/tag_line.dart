import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:easy_localization/easy_localization.dart';

class TagLine extends StatelessWidget {
  final AnimationController textController;
  final Animation<double> textOpacity;

  const TagLine({
    super.key,
    required this.textController,
    required this.textOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: textController,
      builder: (context, child) {
        return Opacity(
          opacity: textOpacity.value,
          child: Text(
            'tagline'.tr(),
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: Colors.white70,
              height: 1.5,
              fontSize: 17.sp,
              letterSpacing: 0.5,
            ),
          ),
        );
      },
    );
  }
}
