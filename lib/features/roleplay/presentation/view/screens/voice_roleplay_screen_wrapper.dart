import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/services/voice_roleplay_service.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/features/roleplay/data/models/roleplay_scenario_model.dart';
import 'package:arabic/features/roleplay/presentation/manager/voice_roleplay_cubit.dart';
import 'package:arabic/features/roleplay/presentation/view/screens/voice_roleplay_screen.dart';

class VoiceRoleplayScreenWrapper extends StatelessWidget {
  final RoleplayScenarioModel scenario;

  const VoiceRoleplayScreenWrapper({super.key, required this.scenario});

  @override
  Widget build(BuildContext context) {
    final languageCode = context.locale.languageCode;
    return BlocProvider(
      create: (context) => VoiceRoleplayCubit(
        service: VoiceRoleplayService(),
        ttsService: TtsService(),
        scenario: scenario,
        languageCode: languageCode,
      ),
      child: const VoiceRoleplayScreen(),
    );
  }
}
