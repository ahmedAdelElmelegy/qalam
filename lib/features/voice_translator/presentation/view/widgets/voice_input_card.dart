import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VoiceInputCard extends StatelessWidget {
  final VoiceTranslatorState state;

  const VoiceInputCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    String text = 'tap_microphone'.tr(context: context);
    bool isListening = false;

    if (currentState is VoiceTranslatorListening) {
      text = currentState.partialText.isEmpty
          ? 'listening'.tr(context: context)
          : currentState.partialText;
      isListening = true;
    } else if (currentState is VoiceTranslatorNoMatch) {
      text = '...';
    } else if (currentState is VoiceTranslatorTranslating) {
      text = currentState.originalText;
    } else if (currentState is VoiceTranslatorSuccess) {
      text = currentState.userSpeech;
    } else if (currentState is VoiceTranslatorError && currentState.originalText.isNotEmpty) {
      text = currentState.originalText;
    } else if (currentState is VoiceTranslatorError && currentState.originalText.isEmpty) {
      text = currentState.error;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isListening
              ? const Color(0xFFD4AF37)
              : Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: isListening
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: const Color(0xFFD4AF37),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'you_said'.tr(context: context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (isListening)
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFD4AF37),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 18.sp,
              color:
                  isListening &&
                          currentState is VoiceTranslatorListening &&
                          currentState.partialText.isEmpty
                      ? Colors.white54
                      : Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
