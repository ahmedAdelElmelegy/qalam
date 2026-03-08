import 'dart:math';
import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/settings/presentation/view/screens/settings_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OasisHomeScreen extends StatelessWidget {
  const OasisHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      _OasisFeature(
        title: 'recordings'.tr(),
        subtitle: 'my_voice_log'.tr(),
        icon: Icons.mic_rounded,
        color: const Color(0xFFF59E0B),
        accentColor: const Color(0xFFFCD34D),
        description: 'review_practice'.tr(),
        routeId: 'recordings',
      ),
      _OasisFeature(
        title: 'dialects'.tr(),
        subtitle: 'choose_dialect'.tr(),
        icon: Icons.language_rounded,
        color: const Color(0xFF06B6D4),
        accentColor: const Color(0xFF67E8F9),
        description: 'explore_arabic'.tr(),
        routeId: 'dialects',
      ),
      _OasisFeature(
        title: 'settings'.tr(),
        subtitle: 'app_settings'.tr(),
        icon: Icons.settings_suggest_rounded,
        color: const Color(0xFF8B5CF6),
        accentColor: const Color(0xFFC4B5FD),
        description: 'personalize_app'.tr(),
        routeId: 'settings',
      ),
      _OasisFeature(
        title: 'help'.tr(),
        subtitle: 'support_center'.tr(),
        icon: Icons.help_center_rounded,
        color: const Color(0xFF10B981),
        accentColor: const Color(0xFF6EE7B7),
        description: 'get_support'.tr(),
        routeId: 'help',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      body: Stack(
        children: [
          // Rich layered background
          const Positioned.fill(child: _OasisBackground()),
          // Decorative geometric shapes
          const Positioned.fill(child: _OasisShapes()),
          // Main content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(child: _buildHeader(context)),
                // Hero section - first 2 as large horizontal cards
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
                    child: Column(
                      children: [
                        _OasisHeroCard(feature: features[0], index: 0),
                        SizedBox(height: 16.h),
                        _OasisHeroCard(feature: features[1], index: 1),
                      ],
                    ),
                  ),
                ),
                // Bottom 2 as smaller grid
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 60.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16.h,
                      crossAxisSpacing: 16.w,
                      childAspectRatio: 1.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _OasisMiniCard(
                        feature: features[index + 2],
                        index: index,
                      ),
                      childCount: 2,
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
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
            ),
          ),
          SizedBox(height: 28.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'oasis_title'.tr(),
                      style: AppTextStyles.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 34.sp,
                        letterSpacing: -2,
                        height: 1.0,
                      ),
                    ).animate().fadeIn().slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuart),
                    SizedBox(height: 6.h),
                    Text(
                      'oasis_subtitle'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.45),
                        letterSpacing: 0.2,
                      ),
                    ).animate().fadeIn(delay: 150.ms),
                  ],
                ),
              ),
              // Oasis emblem
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
                  ),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF06B6D4).withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 6)),
                  ],
                ),
                child: Icon(Icons.waves_rounded, color: Colors.white, size: 26.w)
                    .animate(onPlay: (c) => c.repeat(reverse: true))
                    .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 2.seconds),
              ).animate().fadeIn(delay: 200.ms).scale(begin: const Offset(0.7, 0.7), curve: Curves.easeOutBack),
            ],
          ),
          SizedBox(height: 14.h),
          Container(height: 3.h, width: 50.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF67E8F9)]),
              borderRadius: BorderRadius.circular(2),
            ),
          ).animate().fadeIn(delay: 300.ms).scaleX(begin: 0, alignment: Alignment.centerLeft),
        ],
      ),
    );
  }
}

// --- HERO CARD (horizontal, full-width) ---
class _OasisHeroCard extends StatefulWidget {
  final _OasisFeature feature;
  final int index;
  const _OasisHeroCard({required this.feature, required this.index});
  @override
  State<_OasisHeroCard> createState() => _OasisHeroCardState();
}

class _OasisHeroCardState extends State<_OasisHeroCard> {
  bool _pressed = false;

  void _handleTap(BuildContext context) {
    switch (widget.feature.routeId) {
      case 'settings':
        context.push(const SettingsScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.feature.title} — coming soon!'),
            backgroundColor: widget.feature.color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); _handleTap(context); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,

        duration: const Duration(milliseconds: 180),
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(color: widget.feature.color.withValues(alpha: 0.22), blurRadius: 20, offset: const Offset(0, 8)),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28.r),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      widget.feature.color.withValues(alpha: 0.28),
                      widget.feature.color.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(28.r),
                  border: Border.all(color: widget.feature.color.withValues(alpha: 0.4), width: 1.5),
                ),
                child: Stack(
                  children: [
                    // Decorative geo shape inside card
                    Positioned(
                      right: -15, top: -15,
                      child: CustomPaint(
                        size: const Size(90, 90),
                        painter: _PolygonPainter(sides: 6, color: widget.feature.color.withValues(alpha: 0.09)),
                      ),
                    ),
                    Positioned(
                      right: 80, bottom: -20,
                      child: CustomPaint(
                        size: const Size(50, 50),
                        painter: _PolygonPainter(sides: 3, color: widget.feature.accentColor.withValues(alpha: 0.07)),
                      ),
                    ),
                    // Content row
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 18.h),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [widget.feature.color, widget.feature.color.withValues(alpha: 0.6)]),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [BoxShadow(color: widget.feature.color.withValues(alpha: 0.45), blurRadius: 14, offset: const Offset(0, 5))],
                            ),
                            child: Icon(widget.feature.icon, color: Colors.white, size: 26.w)
                                .animate(onPlay: (c) => c.repeat(reverse: true))
                                .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 2.seconds),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(widget.feature.title,
                                  style: AppTextStyles.h4.copyWith(
                                    color: Colors.white, fontWeight: FontWeight.bold,
                                    fontSize: 18.sp, letterSpacing: -0.5,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(widget.feature.subtitle,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.55), fontSize: 12.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: widget.feature.color.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                              border: Border.all(color: widget.feature.color.withValues(alpha: 0.3)),
                            ),
                            child: Icon(Icons.arrow_forward_ios_rounded, color: widget.feature.accentColor, size: 14.w),
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
    ).animate()
     .fadeIn(delay: (300 + widget.index * 150).ms)
     .slideX(begin: -0.1, end: 0, curve: Curves.easeOutQuart);
  }
}

// --- MINI CARD (grid, square) ---
class _OasisMiniCard extends StatefulWidget {
  final _OasisFeature feature;
  final int index;
  const _OasisMiniCard({required this.feature, required this.index});
  @override
  State<_OasisMiniCard> createState() => _OasisMiniCardState();
}

class _OasisMiniCardState extends State<_OasisMiniCard> {
  bool _pressed = false;

  void _handleTap(BuildContext context) {
    switch (widget.feature.routeId) {
      case 'settings':
        context.push(const SettingsScreen());
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.feature.title} — coming soon!'),
            backgroundColor: widget.feature.color,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) { setState(() => _pressed = false); _handleTap(context); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [widget.feature.color.withValues(alpha: 0.22), widget.feature.color.withValues(alpha: 0.05)],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(color: widget.feature.color.withValues(alpha: 0.35), width: 1.5),
                boxShadow: [BoxShadow(color: widget.feature.color.withValues(alpha: 0.15), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: Stack(
                children: [
                  Positioned(right: -10, top: -10,
                    child: CustomPaint(size: const Size(60, 60),
                      painter: _PolygonPainter(sides: 6, color: widget.feature.color.withValues(alpha: 0.08)))),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(11.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [widget.feature.color, widget.feature.color.withValues(alpha: 0.6)]),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [BoxShadow(color: widget.feature.color.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))],
                          ),
                          child: Icon(widget.feature.icon, color: Colors.white, size: 20.w),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.feature.title,
                              style: AppTextStyles.h4.copyWith(
                                color: Colors.white, fontWeight: FontWeight.bold,
                                fontSize: 14.sp, letterSpacing: -0.3,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(widget.feature.subtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: widget.feature.accentColor.withValues(alpha: 0.7), fontSize: 10.sp,
                              ),
                              maxLines: 1, overflow: TextOverflow.ellipsis,
                            ),
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
     .fadeIn(delay: (600 + widget.index * 120).ms)
     .scale(begin: const Offset(0.85, 0.85), curve: Curves.easeOutBack);
  }
}

// --- Oasis Background ---
class _OasisBackground extends StatelessWidget {
  const _OasisBackground();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [Color(0xFF0D1B2A), Color(0xFF080818), Color(0xFF030308)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -60, right: -80,   child: _Orb(size: 280, color: const Color(0xFF06B6D4).withValues(alpha: 0.12))),
          Positioned(bottom: 100, left: -60, child: _Orb(size: 220, color: const Color(0xFFF59E0B).withValues(alpha: 0.09))),
          Positioned(top: 350, left: 50,     child: _Orb(size: 120, color: const Color(0xFF8B5CF6).withValues(alpha: 0.08))),
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
      width: size, height: size,
      decoration: BoxDecoration(
        color: color, shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: color, blurRadius: size * 0.5, spreadRadius: size * 0.08)],
      ),
    ).animate(onPlay: (c) => c.repeat(reverse: true))
     .scale(begin: const Offset(1, 1), end: const Offset(1.12, 1.12), duration: 5.seconds, curve: Curves.easeInOut)
     .moveY(begin: 0, end: 12, duration: 4.seconds, curve: Curves.easeInOut);
  }
}

// --- Geometric Shapes ---
class _OasisShapes extends StatelessWidget {
  const _OasisShapes();
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(top: 220, right: 18,
          child: CustomPaint(size: const Size(55, 55), painter: _PolygonPainter(sides: 6, color: Colors.white.withValues(alpha: 0.03)))
              .animate(onPlay: (c) => c.repeat(reverse: true)).rotate(begin: 0, end: 0.12, duration: 9.seconds)),
        Positioned(top: 500, left: 15,
          child: CustomPaint(size: const Size(38, 38), painter: _PolygonPainter(sides: 3, color: const Color(0xFF06B6D4).withValues(alpha: 0.08)))
              .animate(onPlay: (c) => c.repeat(reverse: true)).rotate(begin: 0, end: -0.2, duration: 7.seconds)),
        Positioned(bottom: 250, right: 35,
          child: CustomPaint(size: const Size(45, 45), painter: _PolygonPainter(sides: 4, color: const Color(0xFFF59E0B).withValues(alpha: 0.07)))
              .animate(onPlay: (c) => c.repeat(reverse: true)).rotate(begin: 0.1, end: 0.4, duration: 8.seconds)),
      ],
    );
  }
}

class _PolygonPainter extends CustomPainter {
  final int sides;
  final Color color;
  _PolygonPainter({required this.sides, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path();
    final cx = size.width / 2, cy = size.height / 2, r = size.width / 2;
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final x = cx + r * cos(angle), y = cy + r * sin(angle);
      i == 0 ? path.moveTo(x, y) : path.lineTo(x, y);
    }
    path.close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(_PolygonPainter o) => false;
}

class _OasisFeature {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color color;
  final Color accentColor;
  final String routeId;

  _OasisFeature({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.color,
    required this.accentColor,
    required this.routeId,
  });
}
