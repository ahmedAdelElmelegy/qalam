import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/settings/presentation/view/screens/settings_screen.dart';

import 'oasis_feature.dart';
import 'geometric_shapes.dart';

class OasisHeroCard extends StatefulWidget {
  final OasisFeature feature;
  final int index;
  const OasisHeroCard({super.key, required this.feature, required this.index});
  @override
  State<OasisHeroCard> createState() => _OasisHeroCardState();
}

class _OasisHeroCardState extends State<OasisHeroCard> {
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
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        _handleTap(context);
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 180),
        child: Container(
          height: 120.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: widget.feature.color.withValues(alpha: 0.22),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
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
                  border: Border.all(
                    color: widget.feature.color.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -15,
                      top: -15,
                      child: GeoShape(
                        size: 90,
                        sides: 6,
                        color: widget.feature.color.withValues(alpha: 0.09),
                      ),
                    ),
                    Positioned(
                      right: 80,
                      bottom: -20,
                      child: GeoShape(
                        size: 50,
                        sides: 3,
                        color: widget.feature.accentColor.withValues(alpha: 0.07),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 22.w,
                        vertical: 18.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(14.w),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  widget.feature.color,
                                  widget.feature.color.withValues(alpha: 0.6)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(18.r),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.feature.color
                                      .withValues(alpha: 0.45),
                                  blurRadius: 14,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: Icon(
                              widget.feature.icon,
                              color: Colors.white,
                              size: 26.w,
                            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                  begin: const Offset(1, 1),
                                  end: const Offset(1.12, 1.12),
                                  duration: 2.seconds,
                                ),
                          ),
                          SizedBox(width: 18.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.feature.title,
                                  style: AppTextStyles.h4.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  widget.feature.subtitle,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: Colors.white.withValues(alpha: 0.55),
                                    fontSize: 12.sp,
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
                              border: Border.all(
                                color: widget.feature.color
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: widget.feature.accentColor,
                              size: 14.w,
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
    ).animate().fadeIn(delay: (300 + widget.index * 150).ms).slideX(
          begin: -0.1,
          end: 0,
          curve: Curves.easeOutQuart,
        );
  }
}
