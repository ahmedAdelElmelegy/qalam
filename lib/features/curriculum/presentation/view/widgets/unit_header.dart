import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UnitHeader extends StatelessWidget {
  final CurriculumUnit unit;

  const UnitHeader({super.key, required this.unit});

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final unitTitle =
        unit.titleTranslations[locale] ??
        unit.translations[locale] ??
        unit.title;

    return Padding(
      padding: EdgeInsets.only(bottom: 30.h, top: 10.h),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(30.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Text(
              unitTitle.toUpperCase(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white.withValues(alpha: 0.7),
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
