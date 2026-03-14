import 'dart:ui';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_cubit.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';

class VoiceRoleplayScreen extends StatefulWidget {
  const VoiceRoleplayScreen({super.key});

  @override
  State<VoiceRoleplayScreen> createState() => _VoiceRoleplayScreenState();
}

class _VoiceRoleplayScreenState extends State<VoiceRoleplayScreen> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _orbController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _orbController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _orbController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'voice_roleplay_title'.tr(),
          style: AppTextStyles.h3.copyWith(
            color: Colors.white,
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), blurRadius: 10),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Premium 3D Background with parallax
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              bottom: false,
              child: BlocConsumer<VoiceRoleplayCubit, VoiceRoleplayState>(
                listener: (context, state) async {
                  if (state is VoiceRoleplayError) {
                    if (!await NetworkChecker.hasConnection()) {
                      if (context.mounted) {
                        NetworkChecker.showNoNetworkDialog(context);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error.tr(), style: const TextStyle(color: Colors.white)),
                            backgroundColor: Colors.redAccent.withValues(alpha: 0.9),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
                          ),
                        );
                      }
                    }
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<VoiceRoleplayCubit>();
                  final scenario = cubit.scenario;

                  return Column(
                    children: [
                      // Top spacing
                      SizedBox(height: 20.h),
                      
                      // Feedback Overlay (Drops down if there's a correction)
                      if (_hasFeedback(state))
                        _buildAnalysisPane(state),

                      Spacer(),

                      // Central AI Avatar (The core visual)
                      _buildImmersiveAvatar(state, scenario),

                      Spacer(),

                      // Live Transcription & Dynamic Subtitles Box
                      _buildLiveTranscriptionLayer(state),

                      SizedBox(height: 16.h),

                      // Microphone & Bottom Controls Section
                      _buildBottomControls(context, state),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmersiveAvatar(VoiceRoleplayState state, RoleplayScenarioModel scenario) {
    bool isSpeaking = state is VoiceRoleplaySpeaking;
    bool isProcessing = state is VoiceRoleplayProcessing;
    bool isListening = state is VoiceRoleplayListening;

    Color orbColor = isSpeaking
        ? const Color(0xFFD4AF37) // Golden for AI
        : isListening
            ? const Color(0xFFFF3B3B) // Energetic red for listening
            : isProcessing
                ? const Color(0xFF6366F1) // Indigo for thinking
                : scenario.color.withValues(alpha: 0.8); // Idle

    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 1. External Glow Waves (Only when active)
          if (isSpeaking || isListening)
            ...List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  double waveValue = (_pulseController.value + (index * 0.33)) % 1.0;
                  return Container(
                    width: 140.w + (120.w * waveValue),
                    height: 140.w + (120.w * waveValue),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: orbColor.withValues(alpha: (1.0 - waveValue) * 0.3),
                        width: 2,
                      ),
                    ),
                  );
                },
              );
            }),

          // 2. The Main Glowing Orb
          Container(
            width: 160.w,
            height: 160.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  orbColor.withValues(alpha: 1.0),
                  orbColor.withValues(alpha: 0.4),
                  Colors.transparent,
                ],
                stops: const [0.2, 0.6, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: orbColor.withValues(alpha: 0.5),
                  blurRadius: 40,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.white.withValues(alpha: 0.05),
                  child: Center(
                    child: isProcessing
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ).animate().scale()
                        : Icon(
                            isSpeaking ? Icons.volume_up_rounded : (isListening ? Icons.mic_rounded : Icons.face_retouching_natural_rounded),
                            color: Colors.white,
                            size: 50.sp,
                          ).animate(target: isSpeaking ? 1 : 0).scale(duration: 800.ms, begin: const Offset(1, 1), end: const Offset(1.2, 1.2)).then().scale(duration: 800.ms, begin: const Offset(1.2, 1.2), end: const Offset(1, 1)),
                  ),
                ),
              ),
            ),
          ).animate(target: isSpeaking || isListening ? 1 : 0).scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
                duration: 600.ms,
                curve: Curves.elasticOut,
              ),

          // 3. Floating Scenario Hint (Subtle)
          Positioned(
            bottom: 20.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Text(
                scenario.title.tr(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white60,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.5, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveTranscriptionLayer(VoiceRoleplayState state) {
    if (state is VoiceRoleplayListening && state.recognizedText.isNotEmpty) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.03),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Text(
            state.recognizedText,
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
              style: AppTextStyles.arabicBody.copyWith(color: const Color(0xFF6366F1), fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) => Container(
                width: 6.w,
                height: 6.w,
                margin: EdgeInsets.symmetric(horizontal: 2.w),
                decoration: const BoxDecoration(color: Color(0xFF6366F1), shape: BoxShape.circle),
              ).animate(onPlay: (c) => c.repeat()).scale(delay: (i * 200).ms, duration: 600.ms, begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5)).then().scale(duration: 600.ms, begin: const Offset(1.5, 1.5), end: const Offset(0.5, 0.5))),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  bool _hasFeedback(VoiceRoleplayState state) {
    if (state is VoiceRoleplayIdle && state.lastResponse != null) {
      final r = state.lastResponse!;
      return (r.correctionAr.isNotEmpty || r.correctReplyAr.isNotEmpty || r.safetyNoteAr.isNotEmpty || r.tipsAr.isNotEmpty);
    }
    if (state is VoiceRoleplaySpeaking) {
      final r = state.response;
      return (r.correctionAr.isNotEmpty || r.correctReplyAr.isNotEmpty || r.safetyNoteAr.isNotEmpty || r.tipsAr.isNotEmpty);
    }
    return false;
  }

  Widget _buildAnalysisPane(VoiceRoleplayState state) {
    String? correction, correctReply, tips, safetyNote, translation;
    if (state is VoiceRoleplayIdle && state.lastResponse != null) {
      correction = state.lastResponse!.correctionAr;
      correctReply = state.lastResponse!.correctReplyAr;
      tips = state.lastResponse!.tipsAr;
      safetyNote = state.lastResponse!.safetyNoteAr;
      translation = state.lastResponse!.correctionTranslated;
    } else if (state is VoiceRoleplaySpeaking) {
      correction = state.response.correctionAr;
      correctReply = state.response.correctReplyAr;
      tips = state.response.tipsAr;
      safetyNote = state.response.safetyNoteAr;
      translation = state.response.correctionTranslated;
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.15), width: 1),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 30, spreadRadius: -5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (safetyNote != null && safetyNote.isNotEmpty)
                  _buildFeedbackItem(safetyNote, Colors.redAccent, Icons.gpp_maybe_rounded),
                if (correction != null && correction.isNotEmpty)
                  _buildFeedbackItem(correction, const Color(0xFFD4AF37), Icons.auto_awesome_rounded),
                if (translation != null && translation.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, left: 40.w, right: 40.w, bottom: 12.h),
                    child: Text(
                      translation,
                      textAlign: context.locale.languageCode == 'ar' ? TextAlign.right : TextAlign.left,
                      style: AppTextStyles.bodySmall.copyWith(color: Colors.white54, fontStyle: FontStyle.italic),
                    ),
                  ),
                if (correctReply != null && correctReply.isNotEmpty)
                  _buildFeedbackItem(correctReply, const Color(0xFF10B981), Icons.check_circle_rounded),
                if (tips != null && tips.isNotEmpty)
                  _buildFeedbackItem(tips, const Color(0xFF38BDF8), Icons.lightbulb_rounded),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildFeedbackItem(String text, Color color, IconData icon) {
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

  Widget _buildBottomControls(BuildContext context, VoiceRoleplayState state) {
    final isListening = state is VoiceRoleplayListening;
    final isProcessing = state is VoiceRoleplayProcessing;
    final cubit = context.read<VoiceRoleplayCubit>();

    return Container(
      padding: EdgeInsets.only(
        top: 20.h,
        bottom: MediaQuery.of(context).padding.bottom + 30.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Close Session
          _buildSecondaryCircleButton(
            Icons.close_rounded,
            () => Navigator.pop(context),
            Colors.white24,
          ),
          
          SizedBox(width: 40.w),

          // Main Mic Button
          GestureDetector(
            onTap: () async {
              if (isProcessing) return;
              if (isListening) {
                cubit.stopListeningManually();
              } else {
                if (!await NetworkChecker.hasConnection()) {
                  if (context.mounted) NetworkChecker.showNoNetworkDialog(context);
                  return;
                }
                cubit.startListening();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isListening)
                  ...List.generate(2, (i) => Container(
                    width: 90.w + (40.w * (i + 1)),
                    height: 90.w + (40.w * (i + 1)),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.redAccent.withValues(alpha: 0.2)),
                    ),
                  ).animate(onPlay: (c) => c.repeat()).scale(duration: 1.seconds, begin: const Offset(0.8, 0.8), end: const Offset(1.2, 1.2)).fadeIn(duration: 500.ms).then().fadeOut(duration: 500.ms)),
                
                Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: isListening
                          ? [Colors.redAccent, Colors.red.shade900]
                          : [const Color(0xFFD4AF37), const Color(0xFFB8860B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (isListening ? Colors.redAccent : const Color(0xFFD4AF37)).withValues(alpha: 0.4),
                        blurRadius: 25,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    isListening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 44.sp,
                  ),
                ),
              ],
            ),
          ).animate(target: isProcessing ? 0.5 : 1.0).scale(),

          SizedBox(width: 40.w),

          // Help / Tips
          _buildSecondaryCircleButton(
            Icons.lightbulb_outline_rounded,
            () {}, // Could show general roleplay tips
            Colors.white24,
          ),
        ],
      ),
    );
  }

  Widget _buildSecondaryCircleButton(IconData icon, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white10),
        ),
        child: Icon(icon, color: Colors.white, size: 24.w),
      ),
    );
  }
}
