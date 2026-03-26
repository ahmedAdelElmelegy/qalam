import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/chat/presentation/view/screens/penpal_chat_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/level_selector_screen.dart';
import 'package:arabic/features/museum/presentation/view/screens/museum_home_screen.dart';
import 'package:arabic/core/services/groq_chat_service.dart';
import 'package:arabic/features/chat/presentation/manager/penpal_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:arabic/features/roleplay/presentation/view/screens/roleplay_scenarios_screen.dart';
import 'package:arabic/features/speaking_game/presentation/screens/speaking_challenge_levels_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:arabic/features/voice_translator/presentation/view/screens/voice_translator_screen.dart';

class HomeFeatureGrid extends StatelessWidget {
  const HomeFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _FeatureData(
        title: 'lessons'.tr(context: context),
        subtitle: 'subtitle_lessons'.tr(context: context),
        icon: Icons.menu_book_rounded,
        color: const Color(0xFF8B5CF6),
        route: const LevelSelectorScreen(),
      ),

      _FeatureData(
        title: 'chat_buddy_title'.tr(context: context),
        subtitle: 'chat_buddy_subtitle'.tr(context: context),
        icon: Icons.chat_outlined,
        color: const Color(0xFFF59E0B), // Amber color
        route: BlocProvider(
          create: (context) => PenpalCubit(GroqChatService())..loadSessions(),
          child: const PenpalChatScreen(),
        ),
      ),
      _FeatureData(
        title: 'voice_roleplay_title'.tr(context: context),
        subtitle: 'subtitle_ai_chat'.tr(context: context),
        icon: Icons.graphic_eq_rounded,
        color: const Color(0xFF10B981),
        route: const RoleplayScenariosScreen(),
      ),
      _FeatureData(
        title: 'museum'.tr(context: context),
        subtitle: 'subtitle_museum'.tr(context: context),
        icon: Icons.museum_rounded,
        color: const Color(0xFFFFD700),
        route: const MuseumHomeScreen(),
      ),

      _FeatureData(
        title: 'daily_challenge'.tr(context: context),
        subtitle: 'daily_challenge_subtitle'.tr(context: context),
        icon: Icons.quiz_rounded,
        color: const Color(0xFFEF4444), // Red for challenge
        route: const SpeakingChallengeLevelsScreen(),
      ),
      _FeatureData(
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
          (context, index) => _FeatureCard(data: features[index], index: index),
          childCount: features.length,
        ),
      ),
    );
  }
}

class _FeatureCard extends StatefulWidget {
  final _FeatureData data;
  final int index;

  const _FeatureCard({required this.data, required this.index});

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000 + widget.index * 200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        final breathScale = 1.0 + (_breathController.value * 0.02);

        return GestureDetector(
              onTapDown: (_) => setState(() => _isPressed = true),
              onTapUp: (_) {
                setState(() => _isPressed = false);
                context.push(widget.data.route);
              },
              onTapCancel: () => setState(() => _isPressed = false),
              child: Transform.scale(
                scale: _isPressed ? 0.92 : breathScale,
                child: Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) // perspective
                    ..rotateX(_isPressed ? -0.05 : 0)
                    ..rotateY(_isPressed ? 0.05 : 0),
                  alignment: Alignment.center,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: widget.data.color.withValues(
                            alpha: _isPressed ? 0.3 : 0.2,
                          ),
                          blurRadius: _isPressed ? 25 : 20,
                          offset: Offset(0, _isPressed ? 6 : 8),
                          spreadRadius: _isPressed ? 0 : 2,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                widget.data.color.withValues(alpha: 0.25),
                                widget.data.color.withValues(alpha: 0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: widget.data.color.withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Stack(
                            children: [
                              // Animated background glow
                              Positioned(
                                top: -20,
                                right: -20,
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.data.color.withValues(
                                      alpha: 0.15,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.data.color.withValues(
                                          alpha: 0.2,
                                        ),
                                        blurRadius: 30,
                                        spreadRadius: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // Icon with game-like container
                                    Container(
                                      width: 80.w,
                                      height: 80.w,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            widget.data.color,
                                            widget.data.color.withValues(
                                              alpha: 0.7,
                                            ),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: widget.data.color.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                            offset: const Offset(0, 6),
                                            spreadRadius: 2,
                                          ),
                                          // Inner highlight for 3D look
                                          BoxShadow(
                                            color: Colors.white.withValues(
                                              alpha: 0.3,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(-2, -2),
                                          ),
                                        ],
                                      ),
                                      child:
                                          Icon(
                                                widget.data.icon,
                                                color: Colors.white,
                                                size: 38.w,
                                              )
                                              .animate(
                                                onPlay: (controller) =>
                                                    controller.repeat(),
                                              )
                                              .shimmer(
                                                duration: 2.seconds,
                                                color: Colors.white.withValues(
                                                  alpha: 0.4,
                                                ),
                                              )
                                              .moveY(
                                                begin: -3,
                                                end: 3,
                                                duration: 1.5.seconds,
                                                curve: Curves.easeInOut,
                                              ),
                                    ),
                                    SizedBox(height: 16.h),
                                    FittedBox(
                                      child: Text(
                                        widget.data.title,
                                        // maxLines: 1,
                                        style: AppTextStyles.h4.copyWith(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withValues(
                                                alpha: 0.3,
                                              ),
                                              offset: const Offset(0, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    FittedBox(
                                      child: Text(
                                        widget.data.subtitle,
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white.withValues(
                                            alpha: 0.7,
                                          ),
                                          fontSize: 12.sp,
                                        ),
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        // overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: (400 + widget.index * 100).ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart)
            .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
      },
    );
  }
}

class _FeatureData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget route;

  _FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}
