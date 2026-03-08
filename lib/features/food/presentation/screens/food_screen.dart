import 'dart:ui' as ui;
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/custom_image.dart';
import 'package:arabic/features/food/presentation/cubit/food_cubit.dart';
import 'package:arabic/features/food/presentation/cubit/food_state.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/view/widgets/walking_character.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../widgets/food_story_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class FoodScreen extends StatefulWidget {
  const FoodScreen({super.key});

  @override
  State<FoodScreen> createState() => _FoodScreenState();
}

class _FoodScreenState extends State<FoodScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    context.read<FoodCubit>().loadFoodData();
    LocalStorage.getLanguage().then((value) {
      if (!mounted) return;
      setState(() => lang = value ?? 'en');
    });
  }

  @override
  void dispose() {
    _avatarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FoodCubit, FoodState>(
      listener: (context, state) {
        if (state.status == FoodStatus.loaded && _avatarController.value == 0) {
          final height = (350 * state.foodItems.length).h.clamp(1600.h, 5000.h);
          final startT = 150.h / height;
          _avatarController.animateTo(startT, duration: 1.seconds);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.primaryNavy,
          extendBodyBehindAppBar: true,
          appBar: state.isStoryMode ? null : _buildAppBar(context),
          body: Stack(
            children: [
              const Background3D(),
              if (state.status == FoodStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == FoodStatus.error)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 48.w,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Error loading food data',
                          style: AppTextStyles.h3.copyWith(color: Colors.white),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.errorMessage ?? 'Unknown error',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<FoodCubit>().loadFoodData(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                _buildJourneyContent(state),

              if (state.isStoryMode && state.currentFood != null)
                FoodStoryView(
                  food: state.currentFood!,
                  languageCode: lang,
                  onClose: () => context.read<FoodCubit>().toggleViewMode(),
                ).animate().fadeIn(),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: EdgeInsets.all(8.w),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withValues(alpha: 0.3),
              child: BackButton(
                color: AppColors.accentGold,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'culture_food_title'.tr(),
        style: AppTextStyles.h2.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildJourneyContent(FoodState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Container(
            height: (350 * state.foodItems.length).h.clamp(1600.h, 5000.h),
            padding: EdgeInsets.symmetric(vertical: 120.h),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final path = _buildPath(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(constraints.maxWidth, constraints.maxHeight),
                      painter: FoodJourneyPainter(),
                    ),
                    ...state.foodItems.asMap().entries.map((entry) {
                      return _buildFoodIsland(
                        entry.key,
                        entry.value,
                        state.foodItems.length,
                        constraints.maxWidth,
                        constraints.maxHeight,
                        state,
                      );
                    }),
                    _buildAvatar(
                      path,
                      constraints.maxWidth,
                      constraints.maxHeight,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ui.Path _buildPath(double width, double height) {
    final centerX = width * 0.5;
    width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      width * 0.85,
      height * 0.2,
      width * 0.15,
      height * 0.3,
      width * 0.5,
      height * 0.45,
    );
    path.cubicTo(
      width * 0.85,
      height * 0.6,
      width * 0.15,
      height * 0.7,
      width * 0.5,
      height * 0.85,
    );
    path.lineTo(width * 0.5, height);
    return path;
  }

  Widget _buildAvatar(ui.Path path, double width, double height) {
    return AnimatedBuilder(
      animation: _avatarController,
      builder: (context, child) {
        final metrics = path.computeMetrics().first;
        final currentPos = metrics.length * _avatarController.value;
        final nextPos = (currentPos + 10).clamp(0, metrics.length);
        final currentTangent = metrics.getTangentForOffset(currentPos);
        final nextTangent = metrics.getTangentForOffset(nextPos.toDouble());

        final pos = currentTangent?.position ?? Offset(width * 0.5, 0);
        final nextPosition = nextTangent?.position ?? pos;
        final facingRight = nextPosition.dx > pos.dx;
        final isWalking = _avatarController.isAnimating;

        return Positioned(
          left: (pos.dx - 30.w).clamp(0.0, width - 60.w),
          top: pos.dy - 80.h,
          child: WalkingCharacter(
            isWalking: isWalking,
            facingRight: facingRight,
          ),
        );
      },
    );
  }

  Widget _buildFoodIsland(
    int index,
    dynamic food,
    int total,
    double width,
    double height,
    FoodState state,
  ) {
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
          _avatarController
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

                  if (state.selectedFoodIndex == index)
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

class FoodJourneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const Color pathColor = Color(0xFFF59E0B);

    final paint = Paint()
      ..color = pathColor.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.w
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = pathColor.withValues(alpha: 0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 28.w
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);

    final centerX = size.width * 0.5;
    size.width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.2,
      size.width * 0.15,
      size.height * 0.3,
      size.width * 0.5,
      size.height * 0.45,
    );
    path.cubicTo(
      size.width * 0.85,
      size.height * 0.6,
      size.width * 0.15,
      size.height * 0.7,
      size.width * 0.5,
      size.height * 0.85,
    );
    path.lineTo(size.width * 0.5, size.height);

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    final metric = path.computeMetrics().first;
    final dotPaint = Paint()..color = pathColor.withValues(alpha: 0.7);
    final dotGlow = Paint()
      ..color = pathColor.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    for (int i = 0; i <= 40; i++) {
      final pos = metric
          .getTangentForOffset(metric.length * (i / 40))
          ?.position;
      if (pos != null) {
        canvas.drawCircle(pos, 4.w, dotGlow);
        canvas.drawCircle(pos, 2.w, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
