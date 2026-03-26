import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/daily%20challange/presentation/manager/speaking_game_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GameMicSection extends StatelessWidget {
  final bool isListening;
  final String recognizedText;

  const GameMicSection({
    super.key,
    required this.isListening,
    required this.recognizedText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 60.h,
          child: Center(
            child: Text(
              recognizedText.isNotEmpty
                  ? '"$recognizedText"'
                  : (isListening
                      ? 'listening'.tr(context: context)
                      : 'tap_mic_speak'.tr(context: context)),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isListening ? AppColors.accentGold : Colors.white70,
                fontStyle: recognizedText.isNotEmpty ? FontStyle.italic : FontStyle.normal,
              ),
            )
                .animate(
                  key: ValueKey(recognizedText + isListening.toString()),
                )
                .fadeIn(),
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () async {
            final cubit = context.read<SpeakingGameCubit>();
            if (isListening) {
              cubit.stopListening();
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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isListening ? 90.w : 76.w,
            height: isListening ? 90.w : 76.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening ? AppColors.accentGold : Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: isListening
                    ? Colors.white
                    : AppColors.accentGold.withValues(alpha: 0.5),
                width: 2,
              ),
              boxShadow: [
                if (isListening)
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.6),
                    blurRadius: 30,
                    spreadRadius: 10,
                  ),
              ],
            ),
            child: Icon(
              isListening ? Icons.stop_rounded : Icons.mic_rounded,
              color: isListening ? Colors.black : AppColors.accentGold,
              size: 36.w,
            ),
          )
              .animate(target: isListening ? 1 : 0)
              .scale(
                begin: const Offset(1, 1),
                end: const Offset(1.1, 1.1),
              ),
        ),
      ],
    );
  }
}
