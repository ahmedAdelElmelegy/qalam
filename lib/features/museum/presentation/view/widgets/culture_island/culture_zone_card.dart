import 'dart:ui' as ui;
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/museum/data/models/culture_zone_model.dart';
import 'package:arabic/features/museum/presentation/manager/add%20by%20ai/culture_cubit.dart';
import 'package:arabic/features/museum/presentation/view/widgets/culture_island/journey_path_painter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CultureZoneCard extends StatelessWidget {
  final int index;
  final CultureZone zone;
  final int total;
  final Size size;
  final bool isActive;

  const CultureZoneCard({
    super.key,
    required this.index,
    required this.zone,
    required this.total,
    required this.size,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate position along the path based on index
    final t = 0.1 + (index * 0.8 / (total - 1));
    final path = JourneyPathPainter.buildPath(size);
    final metrics = path.computeMetrics().first;
    final pos =
        metrics.getTangentForOffset(metrics.length * t)?.position ??
        Offset.zero;

    final isLeft = index % 2 == 0;

    return Positioned(
      left: isLeft ? pos.dx + 25.w : pos.dx - 125.w,
      top: pos.dy - 105.h,
      child: GestureDetector(
        onTap: () {
          context.read<CultureCubit>().selectZone(zone);
        },
        child: SizedBox(
          width: 150.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon positioned at top
              _buildCardIcon(zone, isActive),

              SizedBox(height: 14.h),

              // Premium Glassmorphism Card
              ClipRRect(
                borderRadius: BorderRadius.circular(24.r),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isActive
                            ? [
                                _getColorForZone(zone.id).withValues(alpha: 0.25),
                                _getColorForZone(zone.id).withValues(alpha: 0.05),
                              ]
                            : [
                                Colors.white.withValues(alpha: 0.12),
                                Colors.white.withValues(alpha: 0.02),
                              ],
                      ),
                      borderRadius: BorderRadius.circular(24.r),
                      border: Border.all(
                        color: isActive
                            ? _getColorForZone(zone.id).withValues(alpha: 0.8)
                            : Colors.white.withValues(alpha: 0.2),
                        width: isActive ? 1.5 : 1.0,
                      ),
                      boxShadow: [
                        if (isActive)
                          BoxShadow(
                            color: _getColorForZone(zone.id).withValues(alpha: 0.4),
                            blurRadius: 25,
                            spreadRadius: 2,
                            offset: const Offset(0, 8),
                          )
                        else
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 15,
                            spreadRadius: 0,
                            offset: const Offset(0, 6),
                          ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          zone.titleAr,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isActive ? _getColorForZone(zone.id) : Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          zone.title.tr(),
                          textAlign: TextAlign.center,
                          style: AppTextStyles.h4.copyWith(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )
          .animate()
          .fadeIn(delay: (150 * index).ms, duration: 600.ms)
          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart)
          .scale(
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
            curve: Curves.easeOutBack,
          ),
    );
  }

  Widget _buildCardIcon(CultureZone zone, bool isActive) {
    final iconData = _getIconForZone(zone.id);
    final iconColor = _getColorForZone(zone.id);

    return Container(
      width: isActive ? 80.w : 70.w,
      height: isActive ? 80.w : 70.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: isActive 
             ? [iconColor.withValues(alpha: 0.4), iconColor.withValues(alpha: 0.1)]
             : [Colors.white.withValues(alpha: 0.15), Colors.white.withValues(alpha: 0.02)],
          stops: const [0.2, 1.0],
        ),
        border: Border.all(
          color: isActive ? iconColor : Colors.white.withValues(alpha: 0.3),
          width: isActive ? 2.5 : 1.5,
        ),
        boxShadow: [
          if (isActive)
            BoxShadow(
              color: iconColor.withValues(alpha: 0.5),
              blurRadius: 25,
              spreadRadius: 4,
            ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
          // Inner glow
          BoxShadow(
            color: isActive ? iconColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: -2,
            blurStyle: BlurStyle.inner,
          ),
        ],
      ),
      child: Center(
        child: Transform.rotate(
          angle: _getRotationForZone(zone.id),
          child: Icon(
            iconData,
            color: isActive ? iconColor : Colors.white70,
            size: isActive ? 36.w : 30.w,
            shadows: [
              if (isActive)
                Shadow(
                  color: iconColor.withValues(alpha: 0.8),
                  blurRadius: 15,
                ),
            ],
          ),
        )
        .animate(onPlay: (controller) {
          if (isActive) controller.repeat(reverse: true);
        })
        .rotate(
          begin: -0.05,
          end: 0.05,
          duration: 2.seconds,
          curve: Curves.easeInOut,
        )
        .scale(
          begin: const Offset(0.95, 0.95),
          end: const Offset(1.05, 1.05),
          duration: 2.seconds,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  double _getRotationForZone(String id) {
    switch (id) {
      case 'history':
        return 0.15; // ~8 degrees
      case 'grammar':
        return -0.1; // ~-6 degrees
      case 'vocabulary':
        return 0.2; // ~11 degrees
      case 'lessons':
        return -0.15; // ~-8 degrees
      case 'culture':
        return 0.1; // ~6 degrees
      case 'food':
        return -0.2; // ~-11 degrees
      case 'clothing':
        return 0.15; // ~8 degrees
      case 'cities':
        return -0.1; // ~-6 degrees
      default:
        return 0.0;
    }
  }

  Color _getColorForZone(String id) {
    switch (id) {
      case 'history':
        return const Color(0xFFD4AF37); // Gold
      case 'grammar':
        return const Color(0xFF6366F1); // Indigo
      case 'vocabulary':
        return const Color(0xFF10B981); // Green
      case 'lessons':
        return const Color(0xFFEC4899); // Pink
      case 'culture':
        return const Color(0xFF8B5CF6); // Purple
      case 'food':
        return const Color(0xFFF59E0B); // Amber/Orange
      case 'clothing':
        return const Color(0xFF10B981); // Emerald/Green
      case 'cities':
        return const Color(0xFF3B82F6); // Blue
      default:
        return AppColors.accentGold;
    }
  }

  IconData _getIconForZone(String id) {
    switch (id) {
      case 'history':
        return Icons.history_edu_rounded;
      case 'grammar':
        return Icons.menu_book_rounded;
      case 'vocabulary':
        return Icons.translate_rounded;
      case 'lessons':
        return Icons.school_rounded;
      case 'culture':
        return Icons.info_rounded;
      case 'food':
        return Icons.restaurant_rounded;
      case 'clothing':
        return Icons.checkroom_rounded;
      case 'cities':
        return Icons.location_city_rounded;
      default:
        return Icons.explore_rounded;
    }
  }
}
