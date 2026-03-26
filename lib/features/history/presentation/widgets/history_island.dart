import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';

class HistoryIsland extends StatelessWidget {
  final int index;
  final dynamic period;
  final int total;
  final double width;
  final double height;
  final dynamic currentPeriod;
  final String lang;
  final AnimationController avatarController;

  const HistoryIsland({
    super.key,
    required this.index,
    required this.period,
    required this.total,
    required this.width,
    required this.height,
    required this.currentPeriod,
    required this.lang,
    required this.avatarController,
  });

  ui.Path _buildPath(double width, double height) {
    final centerX = width * 0.5;
    final curveX = width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      centerX + curveX,
      height * 0.2,
      centerX - curveX,
      height * 0.4,
      centerX,
      height * 0.5,
    );
    path.cubicTo(
      centerX + curveX,
      height * 0.6,
      centerX - curveX,
      height * 0.8,
      centerX,
      height * 1.0,
    );
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final t = 0.1 + (index * 0.8 / (total - 1));
    final path = _buildPath(width, height);
    final metrics = path.computeMetrics().first;
    final pos =
        metrics.getTangentForOffset(metrics.length * t)?.position ??
        Offset.zero;

    final bool isLeft = index % 2 == 1;
    final double horizontalOffset = isLeft ? -160.w : 20.w;
    final double left = (pos.dx + horizontalOffset).clamp(10.w, width - 190.w);

    return Positioned(
      left: left,
      top: pos.dy - 100.h,
      child: GestureDetector(
        onTap: () {
          avatarController
              .animateTo(t, duration: 1.5.seconds, curve: Curves.easeInOutQuad)
              .then((_) {
                context.read<HistoryCubit>().selectPeriod(index);
                context.read<HistoryCubit>().toggleViewMode();
              });
        },
        child: SizedBox(
          width: 180.w,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.accentGold,
                            width: 3,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accentGold.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 15,
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.network(
                            period.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                child: CustomLoadingWidget(size: 30),
                              );
                            },
                          ),
                        ),
                      )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .scale(
                        begin: const Offset(1, 1),
                        end: const Offset(1.1, 1.1),
                        duration: 3.seconds,
                      ),

                  if (currentPeriod?.id == period.id)
                    Container(
                          width: 115.w,
                          height: 115.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.accentGold.withValues(
                                alpha: 0.5,
                              ),
                              width: 2,
                            ),
                          ),
                        )
                        .animate()
                        .scale(
                          begin: const Offset(0.8, 0.8),
                          end: const Offset(1, 1),
                        )
                        .fadeIn(),
                ],
              ),

              SizedBox(height: 12.h),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(15.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      period.getTitle(lang),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      period.getTitle('ar'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: AppTextStyles.arabicTitle.copyWith(
                        color: AppColors.accentGold,
                        fontSize: 15.sp,
                        fontFamily: 'NotoKufiArabic',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      period.yearRange[lang]!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 11.sp,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0),
    );
  }
}
