import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';

class LessonTipCard extends StatelessWidget {
  final String tip;

  const LessonTipCard({super.key, required this.tip});

  static const _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    if (tip.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: _gold, size: 16.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white70,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
