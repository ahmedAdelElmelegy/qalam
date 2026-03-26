import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:arabic/features/roleplay/presentation/view/screens/voice_roleplay_screen_wrapper.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RoleplayScenarioCard extends StatelessWidget {
  final RoleplayScenarioModel scenario;
  final int index;

  const RoleplayScenarioCard({
    super.key,
    required this.scenario,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    
    return GestureDetector(
      onTap: () {
        context.push(VoiceRoleplayScreenWrapper(scenario: scenario));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: scenario.color.withValues(alpha: 0.2),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 2,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    scenario.color.withValues(alpha: 0.25),
                    scenario.color.withValues(alpha: 0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: scenario.color.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                children: [
                  Container(
                    width: 60.w,
                    height: 60.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scenario.color.withValues(alpha: 0.2),
                      border: Border.all(
                        color: scenario.color.withValues(alpha: 0.5),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: scenario.color.withValues(alpha: 0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        scenario.imagePath,
                        fit: BoxFit.cover,
                        width: 60.w,
                        height: 60.w,
                      ),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          scenario.title.tr(),
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          scenario.description.tr(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 14.sp,
                          ),
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Icon(
                    isArabic ? Icons.chevron_left_rounded : Icons.chevron_right_rounded,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 28.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      )
      .animate()
      .fadeIn(delay: (200 + index * 100).ms, duration: 400.ms)
      .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart),
    );
  }
}
