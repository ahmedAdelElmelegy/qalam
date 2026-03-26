import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_cubit.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';

class VoiceRoleplayControls extends StatelessWidget {
  final VoiceRoleplayState state;

  const VoiceRoleplayControls({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
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
                  if (context.mounted) {
                    NetworkChecker.showNoNetworkDialog(context);
                  }
                  return;
                }
                cubit.startListening();
              }
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isListening)
                  ...List.generate(
                    2,
                    (i) => Container(
                      width: 90.w + (40.w * (i + 1)),
                      height: 90.w + (40.w * (i + 1)),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.redAccent.withValues(alpha: 0.2),
                        ),
                      ),
                    ).animate(onPlay: (c) => c.repeat())
                     .scale(
                       duration: 1.seconds,
                       begin: const Offset(0.8, 0.8),
                       end: const Offset(1.2, 1.2),
                     )
                     .fadeIn(duration: 500.ms)
                     .then()
                     .fadeOut(duration: 500.ms),
                  ),
                
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
                        color: (isListening
                                ? Colors.redAccent
                                : const Color(0xFFD4AF37))
                            .withValues(alpha: 0.4),
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

  Widget _buildSecondaryCircleButton(
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
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
