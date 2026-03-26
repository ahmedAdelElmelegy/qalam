import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';

class VoiceRoleplayTranscription extends StatelessWidget {
  final VoiceRoleplayState state;

  const VoiceRoleplayTranscription({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    if (state is VoiceRoleplayListening &&
        (state as VoiceRoleplayListening).recognizedText.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            (state as VoiceRoleplayListening).recognizedText,
            textAlign: TextAlign.center,
            style: AppTextStyles.arabicBody.copyWith(
              color: Colors.white70,
              fontSize: 18.sp,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ).animate().fadeIn();
    }
    
    if (state is VoiceRoleplayProcessing) {
      return Center(
        child: Column(
          children: [
            Text(
              'thinking_dots'.tr(),
              style: AppTextStyles.arabicBody.copyWith(
                color: const Color(0xFF6366F1),
                fontSize: 16.sp,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFF6366F1),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scale(
                      delay: (i * 200).ms,
                      duration: 600.ms,
                      begin: const Offset(0.5, 0.5),
                      end: const Offset(1.5, 1.5),
                    )
                    .then()
                    .scale(
                      duration: 600.ms,
                      begin: const Offset(1.5, 1.5),
                      end: const Offset(0.5, 0.5),
                    ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
