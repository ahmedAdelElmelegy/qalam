import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';

class VoiceRoleplayAvatar extends StatefulWidget {
  final VoiceRoleplayState state;
  final RoleplayScenarioModel scenario;

  const VoiceRoleplayAvatar({
    super.key,
    required this.state,
    required this.scenario,
  });

  @override
  State<VoiceRoleplayAvatar> createState() => _VoiceRoleplayAvatarState();
}

class _VoiceRoleplayAvatarState extends State<VoiceRoleplayAvatar>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isSpeaking = widget.state is VoiceRoleplaySpeaking;
    bool isProcessing = widget.state is VoiceRoleplayProcessing;
    bool isListening = widget.state is VoiceRoleplayListening;

    Color orbColor = isSpeaking
        ? const Color(0xFFD4AF37) // Golden for AI
        : isListening
            ? const Color(0xFFFF3B3B) // Energetic red for listening
            : isProcessing
                ? const Color(0xFF6366F1) // Indigo for thinking
                : widget.scenario.color.withValues(alpha: 0.8); // Idle

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
                widget.scenario.title.tr(),
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
}
