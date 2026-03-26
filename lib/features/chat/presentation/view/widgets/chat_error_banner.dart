import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ChatErrorBanner extends StatelessWidget {
  final String error;

  const ChatErrorBanner({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: Colors.redAccent,
            size: 20,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              error,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white54, size: 16),
            onPressed: () {
              // We need a way to clear the error, maybe a cubit method?
              // For now, let's just show it.
            },
          ),
        ],
      ),
    ).animate().shake();
  }
}
