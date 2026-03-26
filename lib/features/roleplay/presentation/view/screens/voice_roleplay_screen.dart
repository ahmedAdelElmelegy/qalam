import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_cubit.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_state.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';

import '../widgets/voice_roleplay_analysis_pane.dart';
import '../widgets/voice_roleplay_avatar.dart';
import '../widgets/voice_roleplay_controls.dart';
import '../widgets/voice_roleplay_transcription.dart';

class VoiceRoleplayScreen extends StatelessWidget {
  const VoiceRoleplayScreen({super.key});

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
                      if (VoiceRoleplayAnalysisPane.hasFeedback(state))
                        VoiceRoleplayAnalysisPane(state: state),

                      const Spacer(),

                      // Central AI Avatar (The core visual)
                      VoiceRoleplayAvatar(state: state, scenario: scenario),

                      const Spacer(),

                      // Live Transcription & Dynamic Subtitles Box
                      VoiceRoleplayTranscription(state: state),

                      SizedBox(height: 16.h),

                      // Microphone & Bottom Controls Section
                      VoiceRoleplayControls(state: state),
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
}
