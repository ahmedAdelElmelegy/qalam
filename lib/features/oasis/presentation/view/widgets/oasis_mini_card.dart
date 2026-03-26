import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/settings/presentation/view/screens/settings_screen.dart';

import 'oasis_feature.dart';
import 'geometric_shapes.dart';

class OasisMiniCard extends StatefulWidget {
  final OasisFeature feature;
  final int index;
  const OasisMiniCard({super.key, required this.feature, required this.index});
  @override
  State<OasisMiniCard> createState() => _OasisMiniCardState();
}

class _OasisMiniCardState extends State<OasisMiniCard> {
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
                  colors: [
                    widget.feature.color.withValues(alpha: 0.22),
                    widget.feature.color.withValues(alpha: 0.05)
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                border: Border.all(
                  color: widget.feature.color.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.feature.color.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  )
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -10,
                    top: -10,
                    child: GeoShape(
                      size: 60,
                      sides: 6,
                      color: widget.feature.color.withValues(alpha: 0.08),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(11.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.feature.color,
                                widget.feature.color.withValues(alpha: 0.6)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: widget.feature.color.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Icon(
                            widget.feature.icon,
                            color: Colors.white,
                            size: 20.w,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.feature.title,
                              style: AppTextStyles.h4.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              widget.feature.subtitle,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: widget.feature.accentColor
                                    .withValues(alpha: 0.7),
                                fontSize: 10.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
    ).animate().fadeIn(
      delay: Duration(milliseconds: 600 + widget.index * 120),
    ).scale(
      begin: const Offset(0.85, 0.85),
      curve: Curves.easeOutBack,
    );
  }
}
