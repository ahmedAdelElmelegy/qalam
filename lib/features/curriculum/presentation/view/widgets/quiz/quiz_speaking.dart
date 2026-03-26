import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class QuizSpeaking extends StatelessWidget {
  final Question question;
  final bool isChecking;
  final bool isSuccess;
  final bool showSpeakingError;
  final String recognizedWords;
  final bool isRecording;
  final VoidCallback onToggleRecording;

  const QuizSpeaking({
    super.key,
    required this.question,
    required this.isChecking,
    required this.isSuccess,
    required this.showSpeakingError,
    required this.recognizedWords,
    required this.isRecording,
    required this.onToggleRecording,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // User reply bubble
        Align(
          alignment: Alignment.center,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            constraints: BoxConstraints(maxWidth: 280.w),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: isSuccess
                  ? const Color(0xFF10B981).withValues(alpha: 0.12)
                  : showSpeakingError
                      ? Colors.redAccent.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: isSuccess
                    ? const Color(0xFF10B981).withValues(alpha: 0.4)
                    : showSpeakingError
                        ? Colors.redAccent.withValues(alpha: 0.3)
                        : isChecking
                            ? Colors.blueAccent.withValues(alpha: 0.3)
                            : Colors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: recognizedWords.isNotEmpty
                ? Text(
                    recognizedWords,
                    textAlign: TextAlign.right,
                    style: AppTextStyles.arabicBody.copyWith(
                      color: isSuccess
                          ? const Color(0xFF10B981)
                          : showSpeakingError
                              ? Colors.redAccent
                              : Colors.white,
                      fontSize: 20.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                : Text(
                    isChecking
                        ? 'checking'.tr()
                        : isRecording
                            ? 'listening'.tr()
                            : 'quiz_reply_placeholder'.tr(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isChecking ? Colors.blueAccent : Colors.white30,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
          ),
        ).animate().fadeIn(delay: 200.ms),

        // Feedback label
        if (isSuccess || showSpeakingError) ...[
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isSuccess ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
                size: 16.sp,
              ),
              SizedBox(width: 6.w),
              Text(
                isSuccess
                    ? 'quiz_excellent'.tr()
                    : recognizedWords.isEmpty
                        ? 'quiz_did_not_hear'.tr()
                        : 'quiz_try_again'.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSuccess ? const Color(0xFF10B981) : Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ).animate().fadeIn().shake(hz: isSuccess ? 0 : 3),
        ],

        SizedBox(height: 32.h),

        // Mic button
        GestureDetector(
          onTap: onToggleRecording,
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isRecording
                      ? Colors.redAccent.withValues(alpha: 0.15)
                      : isChecking
                          ? Colors.blueAccent.withValues(alpha: 0.15)
                          : isSuccess
                              ? const Color(0xFF10B981).withValues(alpha: 0.1)
                              : const Color(0xFFD4AF37).withValues(alpha: 0.1),
                  border: Border.all(
                    color: isRecording
                        ? Colors.redAccent
                        : isChecking
                            ? Colors.blueAccent
                            : isSuccess
                                ? const Color(0xFF10B981)
                                : const Color(0xFFD4AF37),
                    width: 2.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isRecording
                              ? Colors.redAccent
                              : isChecking
                                  ? Colors.blueAccent
                                  : isSuccess
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFD4AF37))
                          .withValues(
                        alpha: isRecording ? 0.45 : 0.15,
                      ),
                      blurRadius: isRecording ? 24 : 12,
                      spreadRadius: isRecording ? 4 : 1,
                    ),
                  ],
                ),
                child: Center(
                  child: isChecking
                      ? Icon(
                          Icons.sync_rounded,
                          color: Colors.blueAccent,
                          size: 34.sp,
                        )
                          .animate(onPlay: (c) => c.repeat())
                          .rotate(duration: 800.ms)
                      : Icon(
                          isRecording
                              ? Icons.stop_rounded
                              : isSuccess
                                  ? Icons.check_rounded
                                  : Icons.mic_rounded,
                          color: isRecording
                              ? Colors.redAccent
                              : isSuccess
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFD4AF37),
                          size: 34.sp,
                        ),
                ),
              )
                  .animate(target: isRecording ? 1 : 0)
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.08, 1.08),
                    duration: 600.ms,
                    curve: Curves.easeInOut,
                  ),
              SizedBox(height: 12.h),
              Text(
                isRecording
                    ? 'Tap to stop'
                    : isChecking
                        ? 'Checking...'
                        : isSuccess
                            ? 'Correct! Tap again to retry'
                            : 'Tap to speak',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isRecording
                      ? Colors.redAccent
                      : isChecking
                          ? Colors.blueAccent
                          : isSuccess
                              ? const Color(0xFF10B981)
                              : Colors.white54,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
