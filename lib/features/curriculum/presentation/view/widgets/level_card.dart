import 'dart:ui';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/data/models/currecum/level_model.dart';
import 'package:arabic/features/curriculum/presentation/view/screens/lesson_list_screen.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/polygon_painter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LevelCard extends StatefulWidget {
  final LevelModel level;
  final int index;

  const LevelCard({super.key, required this.level, required this.index});

  @override
  State<LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<LevelCard> {
  bool _pressed = false;

  static const _levelMeta = {
    'a0': _LevelMeta(
      color: Color(0xFFD4AF37),
      accent: Color(0xFFFFE066),
      label: 'Foundations',
      icon: Icons.auto_awesome_rounded,
    ),
    'a1': _LevelMeta(
      color: Color(0xFF10B981),
      accent: Color(0xFF6EE7B7),
      label: 'Beginner',
      icon: Icons.start_rounded,
    ),
    'a2': _LevelMeta(
      color: Color(0xFF3B82F6),
      accent: Color(0xFF93C5FD),
      label: 'Elementary',
      icon: Icons.directions_walk_rounded,
    ),
    'b1': _LevelMeta(
      color: Color(0xFF8B5CF6),
      accent: Color(0xFFC4B5FD),
      label: 'Intermediate',
      icon: Icons.hiking_rounded,
    ),
    'b2': _LevelMeta(
      color: Color(0xFFF59E0B),
      accent: Color(0xFFFCD34D),
      label: 'Upper-Inter.',
      icon: Icons.flight_takeoff_rounded,
    ),
    'c1': _LevelMeta(
      color: Color(0xFFEC4899),
      accent: Color(0xFFF9A8D4),
      label: 'Advanced',
      icon: Icons.rocket_launch_rounded,
    ),
    'c2': _LevelMeta(
      color: Color(0xFFEF4444),
      accent: Color(0xFFFCA5A5),
      label: 'Mastery',
      icon: Icons.emoji_events_rounded,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final meta =
        _levelMeta[widget.level.code] ??
        const _LevelMeta(
          color: Color(0xFF4B5563),
          accent: Color(0xFF9CA3AF),
          label: '',
          icon: Icons.school_rounded,
        );
    final isLocked = widget.level.isLocked;

    // Convert to CurriculumLevel for helpers and navigation
    final curriculumLevel = widget.level.toCurriculumLevel();
    final levelTitle = getLevelTitle(curriculumLevel, context);
    final levelDescription = getLevelDescription(curriculumLevel, context);

    return GestureDetector(
      onTapDown: isLocked ? null : (_) => setState(() => _pressed = true),
      onTapUp: isLocked ? null : (_) => setState(() => _pressed = false),
      onTapCancel: isLocked ? null : () => setState(() => _pressed = false),
      onTap: isLocked
          ? null
          : () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LessonListScreen(level: curriculumLevel),
              ),
            ),
      child:
          AnimatedScale(
                scale: _pressed ? 0.96 : 1.0,
                duration: const Duration(milliseconds: 180),
                child: Opacity(
                  opacity: isLocked ? 0.5 : 1.0,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            stops: const [0, 0.6, 1],
                            colors: [
                              meta.color.withValues(alpha: 0.28),
                              meta.color.withValues(alpha: 0.12),
                              meta.color.withValues(alpha: 0.04),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(28.r),
                          border: Border.all(
                            color: isLocked
                                ? Colors.white.withValues(alpha: 0.08)
                                : meta.color.withValues(alpha: 0.45),
                            width: 1.5,
                          ),
                          boxShadow: [
                            if (!isLocked)
                              BoxShadow(
                                color: meta.color.withValues(alpha: 0.18),
                                blurRadius: 22,
                                offset: const Offset(0, 8),
                              ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            // Background hex shape
                            Positioned(
                              right: -20,
                              top: -20,
                              child: CustomPaint(
                                size: const Size(80, 80),
                                painter: PolygonPainter(
                                  sides: 6,
                                  color: meta.color.withValues(alpha: 0.08),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(18.w),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // CEFR badge
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 4.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isLocked
                                          ? Colors.white.withValues(alpha: 0.05)
                                          : meta.color.withValues(alpha: 0.25),
                                      borderRadius: BorderRadius.circular(10.r),
                                      border: Border.all(
                                        color: meta.color.withValues(
                                          alpha: 0.4,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      widget.level.code.toUpperCase(),
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: isLocked
                                            ? Colors.white38
                                            : meta.accent,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 13.sp,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  // Icon
                                  Container(
                                    padding: EdgeInsets.all(12.w),
                                    decoration: BoxDecoration(
                                      gradient: isLocked
                                          ? LinearGradient(
                                              colors: [
                                                Colors.white.withValues(
                                                  alpha: 0.1,
                                                ),
                                                Colors.white.withValues(
                                                  alpha: 0.05,
                                                ),
                                              ],
                                            )
                                          : LinearGradient(
                                              colors: [
                                                meta.color,
                                                meta.color.withValues(
                                                  alpha: 0.6,
                                                ),
                                              ],
                                            ),
                                      borderRadius: BorderRadius.circular(16.r),
                                      boxShadow: isLocked
                                          ? []
                                          : [
                                              BoxShadow(
                                                color: meta.color.withValues(
                                                  alpha: 0.4,
                                                ),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ],
                                    ),
                                    child: Icon(
                                      isLocked ? Icons.lock_rounded : meta.icon,
                                      color: Colors.white,
                                      size: 22.w,
                                    ),
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    levelTitle,
                                    style: AppTextStyles.h4.copyWith(
                                      color: isLocked
                                          ? Colors.white38
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.sp,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    levelDescription.isNotEmpty
                                        ? levelDescription
                                        : meta.label,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isLocked
                                          ? Colors.white24
                                          : meta.accent.withValues(alpha: 0.8),
                                      fontSize: 10.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            // Start arrow (only for unlocked)
                            if (!isLocked)
                              Positioned(
                                right: 14.w,
                                bottom: 14.h,
                                child: Container(
                                  padding: EdgeInsets.all(6.w),
                                  decoration: BoxDecoration(
                                    color: meta.color.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward_rounded,
                                    color: meta.accent,
                                    size: 14.w,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: (300 + widget.index * 100).ms)
              .scale(
                begin: const Offset(0.85, 0.85),
                curve: Curves.easeOutBack,
              ),
    );
  }
}

class _LevelMeta {
  final Color color;
  final Color accent;
  final String label;
  final IconData icon;

  const _LevelMeta({
    required this.color,
    required this.accent,
    required this.label,
    required this.icon,
  });
}
