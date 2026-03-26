import 'package:flutter/material.dart';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/oasis/presentation/view/screens/competition_level_selector_screen.dart';

import 'comp_data.dart';
import 'geometric_shapes.dart';

class HeroCompetitionCard extends StatefulWidget {
  final CompData data;
  const HeroCompetitionCard({super.key, required this.data});
  @override
  State<HeroCompetitionCard> createState() => _HeroCompetitionCardState();
}

class _HeroCompetitionCardState extends State<HeroCompetitionCard> {
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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          height: 180.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.data.color,
                widget.data.color.withValues(alpha: 0.6),
                widget.data.accentColor.withValues(alpha: 0.3)
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.data.color.withValues(alpha: 0.4),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -30,
                child: GeoShape(
                  size: 160,
                  color: Colors.white.withValues(alpha: 0.07),
                  sides: 6,
                ),
              ),
              Positioned(
                right: 60,
                bottom: -20,
                child: GeoShape(
                  size: 80,
                  color: Colors.white.withValues(alpha: 0.05),
                  sides: 3,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.data.badge != null)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          widget.data.badge!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const Spacer(),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.data.icon,
                            color: Colors.white,
                            size: 26.w,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.data.title,
                                style: AppTextStyles.h4.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.sp,
                                ),
                              ),
                              Text(
                                widget.data.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.white.withValues(alpha: 0.75),
                                  fontSize: 12.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: widget.data.color,
                            size: 18.w,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        children: [
                          Container(
                            height: 6.h,
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                          FractionallySizedBox(
                            widthFactor: widget.data.progress,
                            child: Container(
                              height: 6.h,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${(widget.data.progress * 100).toInt()}% Complete',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(
          begin: 0.2,
          end: 0,
          curve: Curves.easeOutBack,
        );
  }
}
