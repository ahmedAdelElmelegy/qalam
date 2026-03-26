import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/voice_translator/data/services/mlkit_translation_service.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_cubit.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';

import '../widgets/language_selector.dart';
import '../widgets/voice_input_card.dart';
import '../widgets/translation_response_card.dart';
import '../widgets/microphone_controls.dart';

class VoiceTranslatorScreen extends StatelessWidget {
  const VoiceTranslatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceTranslatorCubit(
        translationService: MlKitTranslationService(),
        ttsService: TtsService(),
      ),
      child: const _VoiceTranslatorView(),
    );
  }
}

class _VoiceTranslatorView extends StatelessWidget {
  const _VoiceTranslatorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'voice_translator_title'.tr(context: context),
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: BlocListener<VoiceTranslatorCubit, VoiceTranslatorState>(
                listener: (context, state) async {
                  if (state is VoiceTranslatorError) {
                    if (!await NetworkChecker.hasConnection()) {
                      if (context.mounted) {
                        NetworkChecker.showNoNetworkDialog(context);
                      }
                    } else {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.error)),
                        );
                      }
                    }
                  }
                },
                child: Column(
                  children: [
                    Expanded(
                      child: BlocBuilder<VoiceTranslatorCubit, VoiceTranslatorState>(
                        builder: (context, state) {
                          return ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 16.h,
                            ),
                            children: [
                              LanguageSelector(state: state),
                              SizedBox(height: 16.h),
                              VoiceInputCard(state: state),
                              SizedBox(height: 24.h),
                              TranslationResponseCard(state: state),
                            ],
                          );
                        },
                      ),
                    ),
                    const MicrophoneControls(),
                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
