import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_cubit.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MicrophoneControls extends StatelessWidget {
  const MicrophoneControls({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceTranslatorCubit, VoiceTranslatorState>(
      builder: (context, state) {
        final isListening = state is VoiceTranslatorListening;

        return GestureDetector(
          onTap: () async {
            if (isListening) {
              context.read<VoiceTranslatorCubit>().stopListening();
            } else {
              if (!await NetworkChecker.hasConnection()) {
                if (context.mounted) {
                  NetworkChecker.showNoNetworkDialog(context);
                }
                return;
              }
              if (!context.mounted) return;
              context.read<VoiceTranslatorCubit>().startListening();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isListening ? 90.w : 80.w,
            height: isListening ? 90.w : 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening ? Colors.redAccent : const Color(0xFFD4AF37),
              boxShadow: [
                BoxShadow(
                  color: (isListening ? Colors.redAccent : const Color(0xFFD4AF37))
                      .withValues(alpha: 0.4),
                  blurRadius: isListening ? 25 : 15,
                  spreadRadius: isListening ? 5 : 0,
                ),
                if (!isListening)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: Center(
              child: Icon(
                isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: isListening ? 45.sp : 35.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
