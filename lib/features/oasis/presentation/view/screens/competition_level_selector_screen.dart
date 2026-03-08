import 'dart:ui';
import 'package:arabic/core/theme/style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Screen shown when a user taps a competition type.
/// Lists the 6 difficulty levels (Beginner → Hero) for that competition.
class CompetitionLevelSelectorScreen extends StatelessWidget {
  final String competitionId;
  final String competitionTitle;
  final Color color;
  final Color accentColor;
  final IconData icon;

  const CompetitionLevelSelectorScreen({
    super.key,
    required this.competitionId,
    required this.competitionTitle,
    required this.color,
    required this.accentColor,
    required this.icon,
  });

  static const _levels = [
    _LevelInfo(
      id: 'beginner',
      labelEn: 'Beginner',
      labelAr: 'مبتدئ',
      iconData: Icons.play_circle_rounded,
      xp: 0,
      reward: '50 XP',
    ),
    _LevelInfo(
      id: 'elementary',
      labelEn: 'Elementary',
      labelAr: 'أساسي',
      iconData: Icons.trending_up_rounded,
      xp: 500,
      reward: '80 XP',
    ),
    _LevelInfo(
      id: 'intermediate',
      labelEn: 'Intermediate',
      labelAr: 'متوسط',
      iconData: Icons.bolt_rounded,
      xp: 1500,
      reward: '120 XP',
    ),
    _LevelInfo(
      id: 'advanced',
      labelEn: 'Advanced',
      labelAr: 'متقدم',
      iconData: Icons.local_fire_department_rounded,
      xp: 3000,
      reward: '180 XP',
    ),
    _LevelInfo(
      id: 'expert',
      labelEn: 'Expert',
      labelAr: 'خبير',
      iconData: Icons.rocket_launch_rounded,
      xp: 6000,
      reward: '250 XP',
    ),
    _LevelInfo(
      id: 'hero',
      labelEn: 'Hero',
      labelAr: 'بطل',
      iconData: Icons.emoji_events_rounded,
      xp: 10000,
      reward: '400 XP',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    color.withValues(alpha: 0.15),
                    const Color(0xFF080818),
                    const Color(0xFF030308),
                  ],
                ),
              ),
            ),
          ),
          // Floating orb
          Positioned(
            top: -80,
            right: -80,
            child:
                Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: color.withValues(alpha: 0.08),
                            blurRadius: 80,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    )
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(
                      begin: const Offset(1, 1),
                      end: const Offset(1.1, 1.1),
                      duration: 5.seconds,
                    ),
          ),
          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 40.h),
                    itemCount: _levels.length,
                    itemBuilder: (ctx, i) => _LevelCard(
                      level: _levels[i],
                      index: i,
                      accentColor: color,
                      competitionId: competitionId,
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color, color.withValues(alpha: 0.6)],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 24.w),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      competitionTitle,
                      style: AppTextStyles.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 24.sp,
                        letterSpacing: -1,
                      ),
                    ).animate().fadeIn().slideX(begin: 0.2),
                    Text(
                      'choose_difficulty'.tr(context: context),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ).animate().fadeIn(delay: 100.ms),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Container(
                height: 3.h,
                width: 60.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [color, accentColor]),
                  borderRadius: BorderRadius.circular(2),
                ),
              )
              .animate()
              .fadeIn(delay: 200.ms)
              .scaleX(begin: 0, alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}

class _LevelCard extends StatefulWidget {
  final _LevelInfo level;
  final int index;
  final Color accentColor;
  final String competitionId;

  const _LevelCard({
    required this.level,
    required this.index,
    required this.accentColor,
    required this.competitionId,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  bool pressed = false;
  // Gradient per level index
  static const _gradients = [
    [Color(0xFF10B981), Color(0xFF059669)],
    [Color(0xFF3B82F6), Color(0xFF2563EB)],
    [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    [Color(0xFFF59E0B), Color(0xFFD97706)],
    [Color(0xFFEC4899), Color(0xFFDB2777)],
    [Color(0xFFEF4444), Color(0xFFDC2626)],
  ];

  @override
  Widget build(BuildContext context) {
    final colors = _gradients[widget.index];

    return AnimatedScale(
          scale: pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: EdgeInsets.only(bottom: 14.h),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Container(
                  padding: EdgeInsets.all(18.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        colors[0].withValues(alpha: 0.18),
                        colors[0].withValues(alpha: 0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(22.r),
                    border: Border.all(
                      color: colors[0].withValues(alpha: 0.35),
                      width: 1.4,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Level number badge
                      Container(
                        width: 46.w,
                        height: 46.w,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: colors),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: colors[0].withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.level.iconData,
                          color: Colors.white,
                          size: 22.w,
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.level.labelEn.tr(context: context),
                                  style: AppTextStyles.h4.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  widget
                                      .level
                                      .labelAr, // Optional to keep, or just hide if fully localized
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: colors[0].withValues(alpha: 0.8),
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              widget.level.xp == 0
                                  ? 'free_to_play'.tr(context: context)
                                  : 'xp_required'.tr(
                                      context: context,
                                      args: [widget.level.xp.toString()],
                                    ),
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // XP reward tag
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: colors[0].withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: colors[0].withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          widget.level.reward,
                          style: TextStyle(
                            color: colors[0],
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 14.w,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: (200 + widget.index * 80).ms)
        .slideX(begin: 0.1, end: 0, curve: Curves.easeOutQuart);
  }
}

class _LevelInfo {
  final String id;
  final String labelEn;
  final String labelAr;
  final IconData iconData;
  final int xp;
  final String reward;

  const _LevelInfo({
    required this.id,
    required this.labelEn,
    required this.labelAr,
    required this.iconData,
    required this.xp,
    required this.reward,
  });
}
