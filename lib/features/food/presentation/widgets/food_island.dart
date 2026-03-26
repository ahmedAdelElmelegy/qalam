import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_image.dart';
import 'package:arabic/features/food/presentation/cubit/food_cubit.dart';

class FoodIsland extends StatelessWidget {
  final int index;
  final dynamic food;
  final int total;
  final double width;
  final double height;
  final int? selectedFoodIndex;
  final String lang;
  final AnimationController avatarController;

  const FoodIsland({
    super.key,
    required this.index,
    required this.food,
    required this.total,
    required this.width,
    required this.height,
    required this.selectedFoodIndex,
    required this.lang,
    required this.avatarController,
  });

  ui.Path _buildPath(double width, double height) {
    final centerX = width * 0.5;
    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      width * 0.85, height * 0.2, width * 0.15, height * 0.3, width * 0.5, height * 0.45,
    );
    path.cubicTo(
      width * 0.85, height * 0.6, width * 0.15, height * 0.7, width * 0.5, height * 0.85,
    );
    path.lineTo(width * 0.5, height);
    return path;
  }

  @override
  Widget build(BuildContext context) {
    final double startT = 150.h / height;
    final t = total > 1
        ? startT + (index * (0.92 - startT) / (total - 1))
        : startT;
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
                context.read<FoodCubit>().selectFood(index);
                context.read<FoodCubit>().toggleViewMode();
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
                          child: food.gallery.isNotEmpty
                              ? CustomImage(
                                  imagePath: food.gallery.first,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: AppColors.primaryNavy,
                                  child: Icon(
                                    Icons.restaurant,
                                    color: AppColors.accentGold,
                                  ),
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

                  if (selectedFoodIndex == index)
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
                      food.getTitle(lang),
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
                      food.getTitle('ar'),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.visible,
                      style: AppTextStyles.arabicTitle.copyWith(
                        color: AppColors.accentGold,
                        fontSize: 15.sp,
                        fontFamily: 'NotoKufiArabic',
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
