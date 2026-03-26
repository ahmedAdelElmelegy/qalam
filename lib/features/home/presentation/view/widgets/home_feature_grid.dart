import 'package:arabic/features/chat/presentation/view/screens/chat_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/level_selector_screen.dart';
import 'package:arabic/features/museum/presentation/view/screens/museum_home_screen.dart';
import 'package:arabic/core/services/groq_chat_service.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arabic/features/roleplay/presentation/view/screens/roleplay_scenarios_screen.dart';
import 'package:arabic/features/daily%20challange/presentation/view/screens/challenge_levels_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:arabic/features/voice_translator/presentation/view/screens/voice_translator_screen.dart';
import 'home_feature_card.dart';

class HomeFeatureGrid extends StatelessWidget {
  const HomeFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      FeatureData(
        title: 'lessons'.tr(context: context),
        subtitle: 'subtitle_lessons'.tr(context: context),
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF8B5CF6),
        route: const LevelSelectorScreen(),
      ),

      FeatureData(
        title: 'chat_buddy_title'.tr(context: context),
        subtitle: 'chat_buddy_subtitle'.tr(context: context),
        icon: Icons.chat_outlined,
        color: const Color(0xFFF59E0B), // Amber color
        route: BlocProvider(
          create: (context) => PenpalCubit(GroqChatService())..loadSessions(),
          child: const ChatScreen(),
        ),
      ),
      FeatureData(
        title: 'voice_roleplay_title'.tr(context: context),
        subtitle: 'subtitle_ai_chat'.tr(context: context),
        icon: Icons.graphic_eq_rounded,
        color: const Color(0xFF10B981),
        route: const RoleplayScenariosScreen(),
      ),
      FeatureData(
        title: 'museum'.tr(context: context),
        subtitle: 'subtitle_museum'.tr(context: context),
        icon: Icons.museum_rounded,
        color: const Color(0xFFFFD700),
        route: const MuseumHomeScreen(),
      ),

      FeatureData(
        title: 'daily_challenge'.tr(context: context),
        subtitle: 'daily_challenge_subtitle'.tr(context: context),
        icon: Icons.quiz_rounded,
        color: const Color(0xFFEF4444), // Red for challenge
        route: const ChallengeLevelsScreen(),
      ),
      FeatureData(
        title: 'voice_translator_title'.tr(context: context),
        subtitle: 'voice_translator_subtitle'.tr(context: context),
        icon: Icons.record_voice_over_rounded,
        color: const Color(0xFF3B82F6), // Blue
        route: const VoiceTranslatorScreen(),
      ),
    ];

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 900
              ? 4
              : MediaQuery.of(context).size.width > 600
              ? 3
              : 2,
          mainAxisSpacing: 20.h,
          crossAxisSpacing: 20.w,
          childAspectRatio: MediaQuery.of(context).size.width > 900
              ? 1.1
              : MediaQuery.of(context).size.width > 600
              ? 1.0
              : 0.85,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => HomeFeatureCard(data: features[index], index: index),
          childCount: features.length,
        ),
      ),
    );
  }
}
