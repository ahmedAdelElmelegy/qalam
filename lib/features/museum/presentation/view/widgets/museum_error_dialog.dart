import 'package:arabic/core/theme/colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MuseumErrorDialog extends StatelessWidget {
  final String message;
  final String? title;
  final VoidCallback? onRetry;

  const MuseumErrorDialog({
    super.key,
    required this.message,
    this.title,
    this.onRetry,
  });

  static void show(BuildContext context, String message, {String? title, VoidCallback? onRetry}) {
    showDialog(
      context: context,
      builder: (context) => MuseumErrorDialog(
        message: message,
        title: title,
        onRetry: onRetry,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(28.w),
        decoration: BoxDecoration(
          color: const Color(0xFF12122A),
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 40,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: 0.12),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.35),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                color: AppColors.error,
                size: 36.sp,
              ),
            ),

            SizedBox(height: 20.h),

            // Title
            Text(
              title ?? 'error_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),

            SizedBox(height: 10.h),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white60,
                height: 1.5,
              ),
            ),

            SizedBox(height: 28.h),

            // Buttons
            Row(
              children: [
                if (onRetry != null) ...[
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'cancel'.tr(),
                        style: const TextStyle(color: Colors.white54),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onRetry != null) {
                        onRetry!();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentGold,
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      (onRetry != null ? 'retry' : 'ok').tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
