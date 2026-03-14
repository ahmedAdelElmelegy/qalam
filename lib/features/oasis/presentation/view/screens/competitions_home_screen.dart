import 'dart:math';
import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/oasis/presentation/view/screens/competition_level_selector_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompetitionsHomeScreen extends StatelessWidget {
  const CompetitionsHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final competitions = [
      _CompData(
        typeId: 'word_challenge',
        title: 'word_challenge'.tr(),
        description: 'test_vocabulary'.tr(),
        icon: Icons.abc_rounded,
        color: const Color(0xFF10B981),
        accentColor: const Color(0xFF6EE7B7),
        progress: 0.7,
        badge: '★ Top Pick',
      ),
      _CompData(
        typeId: 'sentence_puzzle',
        title: 'sentence_puzzle'.tr(),
        description: 'fix_grammar'.tr(),
        icon: Icons.extension_rounded,
        color: const Color(0xFF3B82F6),
        accentColor: const Color(0xFF93C5FD),
        progress: 0.3,
        badge: null,
      ),
      _CompData(
        typeId: 'conversation_master',
        title: 'conversation_master'.tr(),
        description: 'chat_with_ai'.tr(),
        icon: Icons.forum_rounded,
        color: const Color(0xFF8B5CF6),
        accentColor: const Color(0xFFC4B5FD),
        progress: 0.5,
        badge: '🔥 Hot',
      ),
      _CompData(
        typeId: 'voice_pro',
        title: 'voice_pro'.tr(),
        description: 'pronounce_well'.tr(),
        icon: Icons.keyboard_voice_rounded,
        color: const Color(0xFFF59E0B),
        accentColor: const Color(0xFFFCD34D),
        progress: 0.2,
        badge: null,
      ),
      _CompData(
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
          const Positioned.fill(child: _RichBackground()),
          // Geometric floating shapes
          const Positioned.fill(child: _GeometricShapes()),
          // Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                // Hero card (first competition)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 20.h),
                    child: _HeroCompetitionCard(data: competitions[0]),
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
                      (context, index) => _CompetitionCard(
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

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24.w, 24.h, 24.w, 32.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'competitions_title'.tr(),
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 32.sp,
                        letterSpacing: -1.5,
                        height: 1.1,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuart),
                    SizedBox(height: 8.h),
                    Text(
                      'challenges'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFFFE066)]),
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [BoxShadow(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Text(
                  '5 Arenas',
                  style: AppTextStyles.bodySmall.copyWith(color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.8, 0.8)),
            ],
          ),
          SizedBox(height: 12.h),
          Container(height: 3.h, width: 50.w, decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFD4AF37), Color(0xFFFFE066)]),
            borderRadius: BorderRadius.circular(2),
          )).animate().fadeIn(delay: 300.ms).scaleX(begin: 0, alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}

class _HeroCompetitionCard extends StatefulWidget {
  final _CompData data;
  const _HeroCompetitionCard({required this.data});
  @override
  State<_HeroCompetitionCard> createState() => _HeroCompetitionCardState();
}

class _HeroCompetitionCardState extends State<_HeroCompetitionCard> {
  bool _pressed = false;

  void _navigate(BuildContext context) {
    context.push(CompetitionLevelSelectorScreen(
      competitionId: widget.data.typeId,
      competitionTitle: widget.data.title,
      color: widget.data.color,
      accentColor: widget.data.accentColor,
      icon: widget.data.icon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); _navigate(context); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.data.color, widget.data.color.withValues(alpha: 0.6), widget.data.accentColor.withValues(alpha: 0.3)],
            ),
            boxShadow: [
              BoxShadow(color: widget.data.color.withValues(alpha: 0.4), blurRadius: 24, offset: const Offset(0, 12)),
            ],
          ),
          child: Stack(
            children: [
              // Large decorative shape
              Positioned(right: -20, top: -30, child: _GeoShape(size: 160, color: Colors.white.withValues(alpha: 0.07), sides: 6)),
              Positioned(right: 60, bottom: -20, child: _GeoShape(size: 80, color: Colors.white.withValues(alpha: 0.05), sides: 3)),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.data.badge != null)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(widget.data.badge!, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontSize: 11.sp, fontWeight: FontWeight.bold)),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                          child: Icon(widget.data.icon, color: Colors.white, size: 26.w),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.data.title, style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.sp)),
                              Text(widget.data.description, style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.75), fontSize: 12.sp)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                          child: Icon(Icons.arrow_forward_rounded, color: widget.data.color, size: 18.w),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    // Glowing progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(height: 6.h, color: Colors.white.withValues(alpha: 0.2)),
                          FractionallySizedBox(
                            widthFactor: widget.data.progress,
                            child: Container(height: 6.h, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text('${(widget.data.progress * 100).toInt()}% Complete', style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.75), fontSize: 10.sp)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2, end: 0, curve: Curves.easeOutBack);
  }
}

class _CompetitionCard extends StatefulWidget {
  final _CompData data;
  final int index;
  const _CompetitionCard({required this.data, required this.index});
  @override
  State<_CompetitionCard> createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<_CompetitionCard> {
  bool _pressed = false;

  void _navigate(BuildContext context) {
    context.push(CompetitionLevelSelectorScreen(
      competitionId: widget.data.typeId,
      competitionTitle: widget.data.title,
      color: widget.data.color,
      accentColor: widget.data.accentColor,
      icon: widget.data.icon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); _navigate(context); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.data.color.withValues(alpha: 0.22),
                    widget.data.color.withValues(alpha: 0.06),
                  ],
                ),
                borderRadius: BorderRadius.circular(28.r),
                border: Border.all(color: widget.data.color.withValues(alpha: 0.35), width: 1.5),
                boxShadow: [
                  BoxShadow(color: widget.data.color.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8)),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(right: -15, top: -15, child: _GeoShape(size: 70, color: widget.data.color.withValues(alpha: 0.1), sides: 6)),
                  if (widget.data.badge != null)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: widget.data.color.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: widget.data.color.withValues(alpha: 0.5)),
                        ),
                        child: Text(widget.data.badge!, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontSize: 9.sp, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [widget.data.color, widget.data.color.withValues(alpha: 0.6)]),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [BoxShadow(color: widget.data.color.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))],
                          ),
                          child: Icon(widget.data.icon, color: Colors.white, size: 24.w)
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 2.seconds),
                        ),
                        const Spacer(),
                        Text(
                          widget.data.title,
                          style: AppTextStyles.h4.copyWith(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          widget.data.description,
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white.withValues(alpha: 0.55), fontSize: 10.sp),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10.h),
                        // Progress
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Stack(
                                  children: [
                                    Container(height: 5.h, color: Colors.white.withValues(alpha: 0.1)),
                                    FractionallySizedBox(
                                      widthFactor: widget.data.progress,
                                      child: Container(height: 5.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(colors: [widget.data.color, widget.data.accentColor]),
                                          boxShadow: [BoxShadow(color: widget.data.color.withValues(alpha: 0.6), blurRadius: 4)],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text('${(widget.data.progress * 100).toInt()}%',
                              style: AppTextStyles.bodySmall.copyWith(color: widget.data.accentColor, fontSize: 10.sp, fontWeight: FontWeight.bold)),
                          ],
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
    ).animate()
     .fadeIn(delay: (400 + widget.index * 120).ms)
     .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
  }
}

// --- Rich Background ---
class _RichBackground extends StatelessWidget {
  const _RichBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment(0, -0.5),
          radius: 1.2,
          colors: [Color(0xFF1A1040), Color(0xFF0A0A1A), Color(0xFF050510)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -80, left: -80, child: _Orb(size: 280, color: const Color(0xFF6366F1).withValues(alpha: 0.12))),
          Positioned(bottom: 100, right: -60, child: _Orb(size: 220, color: const Color(0xFFEC4899).withValues(alpha: 0.1))),
          Positioned(top: 300, right: 50, child: _Orb(size: 120, color: const Color(0xFF10B981).withValues(alpha: 0.08))),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  final double size;
  final Color color;
  const _Orb({required this.size, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: size * 0.5, spreadRadius: size * 0.1)],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 4.seconds, curve: Curves.easeInOut)
     .moveY(begin: 0, end: 15, duration: 5.seconds, curve: Curves.easeInOut);
  }
}

// --- Geometric Shapes ---
class _GeometricShapes extends StatelessWidget {
  const _GeometricShapes();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 200, right: 20, child: _GeoShape(size: 60, color: Colors.white.withValues(alpha: 0.03), sides: 6)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(begin: 0, end: 0.1, duration: 8.seconds)),
        Positioned(top: 450, left: 10, child: _GeoShape(size: 40, color: const Color(0xFFD4AF37).withValues(alpha: 0.08), sides: 3)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(begin: 0, end: -0.15, duration: 6.seconds)),
        Positioned(bottom: 350, right: 30, child: _GeoShape(size: 50, color: const Color(0xFFEC4899).withValues(alpha: 0.06), sides: 4)
            .animate(onPlay: (c) => c.repeat(reverse: true))
            .rotate(begin: 0.2, end: 0.5, duration: 7.seconds)),
      ],
    );
  }
}

class _GeoShape extends StatelessWidget {
  final double size;
  final Color color;
  final int sides;
  const _GeoShape({required this.size, required this.color, required this.sides});
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _PolygonPainter(sides: sides, color: color),
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;
  _PolygonPainter({required this.sides, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    final path = Path();
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final x = cx + r * cos(angle);
      final y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_PolygonPainter oldDelegate) => false;
}

class _CompData {
  final String typeId;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final double progress;
  final String? badge;

  _CompData({
    required this.typeId,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.progress,
    this.badge,
  });
}
