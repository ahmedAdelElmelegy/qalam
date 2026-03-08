import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.displayMedium.copyWith(fontSize: 22.sp),
            ).animate().fadeIn(delay: 600.ms).slideX(begin: -0.2, end: 0),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
            ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2, end: 0),
          ],
        ),
      ),
    );
  }
}
