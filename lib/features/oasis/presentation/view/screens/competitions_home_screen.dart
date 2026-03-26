import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/comp_data.dart';
import '../widgets/competition_card.dart';
import '../widgets/competitions_header.dart';
import '../widgets/competitions_rich_background.dart';
import '../widgets/geometric_shapes.dart';
import '../widgets/hero_competition_card.dart';

class CompetitionsHomeScreen extends StatelessWidget {
  const CompetitionsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final competitions = [
      CompData(
        typeId: 'word_challenge',
        title: 'word_challenge'.tr(),
        description: 'test_vocabulary'.tr(),
        icon: Icons.abc_rounded,
        color: const Color(0xFF10B981),
        accentColor: const Color(0xFF6EE7B7),
        progress: 0.7,
        badge: '★ Top Pick',
      ),
      CompData(
        typeId: 'sentence_puzzle',
        title: 'sentence_puzzle'.tr(),
        description: 'fix_grammar'.tr(),
        icon: Icons.extension_rounded,
        color: const Color(0xFF3B82F6),
        accentColor: const Color(0xFF93C5FD),
        progress: 0.3,
        badge: null,
      ),
      CompData(
        typeId: 'conversation_master',
        title: 'conversation_master'.tr(),
        description: 'chat_with_ai'.tr(),
        icon: Icons.forum_rounded,
        color: const Color(0xFF8B5CF6),
        accentColor: const Color(0xFFC4B5FD),
        progress: 0.5,
        badge: '🔥 Hot',
      ),
      CompData(
        typeId: 'voice_pro',
        title: 'voice_pro'.tr(),
        description: 'pronounce_well'.tr(),
        icon: Icons.keyboard_voice_rounded,
        color: const Color(0xFFF59E0B),
        accentColor: const Color(0xFFFCD34D),
        progress: 0.2,
        badge: null,
      ),
      CompData(
        typeId: 'riddles',
        title: 'riddles'.tr(),
        description: 'fun_puzzles'.tr(),
        icon: Icons.psychology_rounded,
        color: const Color(0xFFEC4899),
        accentColor: const Color(0xFFF9A8D4),
        progress: 0.9,
        badge: '🏆 Master',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A1A),
      body: Stack(
        children: [
          // Rich gradient background
          const Positioned.fill(child: CompetitionsRichBackground()),
          // Geometric floating shapes
          const Positioned.fill(child: GeometricShapes()),
          // Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                const SliverToBoxAdapter(child: CompetitionsHeader()),
                // Hero card (first competition)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
                    child: HeroCompetitionCard(data: competitions[0]),
                  ),
                ),
                // Rest in 2-col grid
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 60.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 0.82,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => CompetitionCard(
                        data: competitions[index + 1],
                        index: index,
                      ),
                      childCount: competitions.length - 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
