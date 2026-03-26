import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_cubit.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TranslationResponseCard extends StatelessWidget {
  final VoiceTranslatorState state;

  const TranslationResponseCard({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final currentState = state;
    Widget content;

    if (currentState is VoiceTranslatorNoMatch) {
      content = Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Icon(
              Icons.hearing_disabled_outlined,
              color: Colors.amber,
              size: 32.sp,
            ).animate().shake(duration: 400.ms),
            SizedBox(height: 12.h),
            Text(
              'no_match'.tr(context: context),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'no_match_hint'.tr(context: context),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
            ),
          ],
        ),
      );
    } else if (currentState is VoiceTranslatorTranslating) {
      content = Column(
        children: [
          SizedBox(height: 20.h),
          const Center(
            child: CircularProgressIndicator(color: Color(0xFF10B981)),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'translating_now'.tr(context: context),
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
            ),
          ),
        ],
      );
    } else if (currentState is VoiceTranslatorSuccess) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DefaultTextStyle(
            style: AppTextStyles.arabicBody.copyWith(
              fontSize: 26.sp,
              color: Colors.white,
              height: 1.6,
            ),
            textAlign: TextAlign.right,
            child: AnimatedTextKit(
              key: ValueKey(currentState.aiArabicReply),
              animatedTexts: [
                TyperAnimatedText(
                  currentState.aiArabicReply,
                  speed: const Duration(milliseconds: 40),
                  textStyle: AppTextStyles.arabicBody.copyWith(
                    fontSize: 26.sp,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),
          if (currentState.aiTranslation.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.white.withValues(alpha: 0.1)),
            SizedBox(height: 12.h),
            Text(
              currentState.aiTranslation,
              textAlign: TextAlign.left,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 16.sp,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: currentState.isSpeaking
                    ? const Color(0xFF10B981).withValues(alpha: 0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  context.read<VoiceTranslatorCubit>().replayTranslation();
                },
                icon: Icon(
                  currentState.isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                  color: currentState.isSpeaking ? const Color(0xFF10B981) : Colors.white54,
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (currentState is VoiceTranslatorError) {
      content = Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Text(
          currentState.error,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.redAccent,
            fontSize: 14.sp,
          ),
        ),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Text(
          'translation_placeholder'.tr(context: context),
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white30,
            fontSize: 16.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: const Color(0xFF10B981),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'translation'.tr(context: context).toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }
}
