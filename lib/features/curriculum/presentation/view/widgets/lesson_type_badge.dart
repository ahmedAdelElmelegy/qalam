import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LessonTypeBadge extends StatelessWidget {
  final String type;
  final int estimatedMinutes;

  const LessonTypeBadge({
    super.key,
    required this.type,
    required this.estimatedMinutes,
  });

  Color _getTypeColor() {
    switch (type) {
      case 'alphabet':
        return const Color(0xFF3B82F6);
      case 'vocabulary':
        return const Color(0xFF10B981);
      case 'grammar':
        return const Color(0xFF8B5CF6);
      case 'review':
        return const Color(0xFFD4AF37);
      case 'listening':
        return const Color(0xFFEC4899);
      default:
        return Colors.white;
    }
  }

  IconData _getTypeIcon() {
    switch (type) {
      case 'alphabet':
        return Icons.abc_rounded;
      case 'vocabulary':
        return Icons.translate_rounded;
      case 'grammar':
        return Icons.architecture_rounded;
      case 'review':
        return Icons.refresh_rounded;
      case 'listening':
        return Icons.headset_rounded;
      default:
        return Icons.book_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _getTypeColor().withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(), color: _getTypeColor(), size: 16.w),
          SizedBox(width: 8.w),
          Text(
            type.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getTypeColor(),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            Icons.timer_outlined,
            color: _getTypeColor().withValues(alpha: 0.7),
            size: 13.w,
          ),
          SizedBox(width: 4.w),
          Text(
            '$estimatedMinutes min',
            style: AppTextStyles.bodySmall.copyWith(
              color: _getTypeColor().withValues(alpha: 0.7),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }
}
