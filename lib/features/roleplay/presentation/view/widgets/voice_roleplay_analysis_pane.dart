import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';

class VoiceRoleplayAnalysisPane extends StatelessWidget {
  final VoiceRoleplayState state;

  const VoiceRoleplayAnalysisPane({
    super.key,
    required this.state,
  });

  static bool hasFeedback(VoiceRoleplayState state) {
    if (state is VoiceRoleplayIdle && state.lastResponse != null) {
      final r = state.lastResponse!;
      return (r.correctionAr.isNotEmpty ||
          r.correctReplyAr.isNotEmpty ||
          r.safetyNoteAr.isNotEmpty ||
          r.tipsAr.isNotEmpty);
    }
    if (state is VoiceRoleplaySpeaking) {
      final r = state.response;
      return (r.correctionAr.isNotEmpty ||
          r.correctReplyAr.isNotEmpty ||
          r.safetyNoteAr.isNotEmpty ||
          r.tipsAr.isNotEmpty);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    String? correction, correctReply, tips, safetyNote, translation;
    
    if (state is VoiceRoleplayIdle &&
        (state as VoiceRoleplayIdle).lastResponse != null) {
      final r = (state as VoiceRoleplayIdle).lastResponse!;
      correction = r.correctionAr;
      correctReply = r.correctReplyAr;
      tips = r.tipsAr;
      safetyNote = r.safetyNoteAr;
      translation = r.correctionTranslated;
    } else if (state is VoiceRoleplaySpeaking) {
      final r = (state as VoiceRoleplaySpeaking).response;
      correction = r.correctionAr;
      correctReply = r.correctReplyAr;
      tips = r.tipsAr;
      safetyNote = r.safetyNoteAr;
      translation = r.correctionTranslated;
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 30,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (safetyNote != null && safetyNote.isNotEmpty)
                  _buildFeedbackItem(
                    context,
                    safetyNote,
                    Colors.redAccent,
                    Icons.gpp_maybe_rounded,
                  ),
                if (correction != null && correction.isNotEmpty)
                  _buildFeedbackItem(
                    context,
                    correction,
                    const Color(0xFFD4AF37),
                    Icons.auto_awesome_rounded,
                  ),
                if (translation != null && translation.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(
                      top: 4.h,
                      left: 40.w,
                      right: 40.w,
                      bottom: 12.h,
                    ),
                    child: Text(
                      translation,
                      textAlign: context.locale.languageCode == 'ar'
                          ? TextAlign.right
                          : TextAlign.left,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                if (correctReply != null && correctReply.isNotEmpty)
                  _buildFeedbackItem(
                    context,
                    correctReply,
                    const Color(0xFF10B981),
                    Icons.check_circle_rounded,
                  ),
                if (tips != null && tips.isNotEmpty)
                  _buildFeedbackItem(
                    context,
                    tips,
                    const Color(0xFF38BDF8),
                    Icons.lightbulb_rounded,
                  ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFeedbackItem(
    BuildContext context,
    String text,
    Color color,
    IconData icon,
  ) {
    final isArabic = context.locale.languageCode == 'ar';
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 20.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              textDirection: TextDirection.rtl, // Content is always Arabic
              style: AppTextStyles.arabicBody.copyWith(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 16.sp,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
