import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/oasis/presentation/view/screens/competition_level_selector_screen.dart';

import 'comp_data.dart';
import 'geometric_shapes.dart';

class CompetitionCard extends StatefulWidget {
  final CompData data;
  final int index;
  const CompetitionCard({super.key, required this.data, required this.index});
  @override
  State<CompetitionCard> createState() => _CompetitionCardState();
}

class _CompetitionCardState extends State<CompetitionCard> {
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
      onTapUp: (_) {
        setState(() => _pressed = false);
        _navigate(context);
      },
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
                border: Border.all(
                  color: widget.data.color.withValues(alpha: 0.35),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.data.color.withValues(alpha: 0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: -15,
                    top: -15,
                    child: GeoShape(
                      size: 70,
                      color: widget.data.color.withValues(alpha: 0.1),
                      sides: 6,
                    ),
                  ),
                  if (widget.data.badge != null)
                    Positioned(
                      top: 12.h,
                      right: 12.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: widget.data.color.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: widget.data.color.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          widget.data.badge!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                            gradient: LinearGradient(
                              colors: [
                                widget.data.color,
                                widget.data.color.withValues(alpha: 0.6)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: widget.data.color.withValues(alpha: 0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.data.icon,
                            color: Colors.white,
                            size: 24.w,
                          ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(
                                begin: const Offset(1, 1),
                                end: const Offset(1.15, 1.15),
                                duration: 2.seconds,
                              ),
                        ),
                        const Spacer(),
                        Text(
                          widget.data.title,
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          widget.data.description,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 10.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 5.h,
                                      color: Colors.white.withValues(alpha: 0.1),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: widget.data.progress,
                                      child: Container(
                                        height: 5.h,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              widget.data.color,
                                              widget.data.accentColor
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: widget.data.color
                                                  .withValues(alpha: 0.6),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '${(widget.data.progress * 100).toInt()}%',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: widget.data.accentColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
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
      delay: Duration(milliseconds: 400 + widget.index * 120),
    ).scale(
      begin: const Offset(0.85, 0.85),
      curve: Curves.easeOutBack,
    );
  }
}
