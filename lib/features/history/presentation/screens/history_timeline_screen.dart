import 'dart:ui' as ui;
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/museum/presentation/view/widgets/walking_character.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:arabic/features/history/presentation/cubit/history_cubit.dart';
import 'package:arabic/features/history/presentation/cubit/history_state.dart';
import 'package:arabic/features/history/presentation/widgets/story_mode_view.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';

class HistoryTimelineScreen extends StatefulWidget {
  const HistoryTimelineScreen({super.key});

  @override
  State<HistoryTimelineScreen> createState() => _HistoryTimelineScreenState();
}

class _HistoryTimelineScreenState extends State<HistoryTimelineScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _avatarController;
  String lang = 'en';

  @override
  void initState() {
    super.initState();
    _avatarController = AnimationController(vsync: this, duration: 2.seconds);
    _avatarController.animateTo(0.1, duration: 1.seconds);
    context.read<HistoryCubit>().loadHistory();
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
    return BlocConsumer<HistoryCubit, HistoryState>(
      listener: (context, state) {
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
              if (state.status == HistoryStatus.loading)
                const CustomLoadingWidget()
              else if (state.status == HistoryStatus.error)
                const Center(child: Text('Error loading history'))
              else
                _buildJourneyContent(state),

              // Overlay Story Mode
              if (state.isStoryMode && state.currentPeriod != null)
                StoryModeView(
                  period: state.currentPeriod!,
                  languageCode: lang,
                  onClose: () => context.read<HistoryCubit>().toggleViewMode(),
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
                onPressed: () => context.pop(),
              ),
            ),
          ),
        ),
      ),
      title: Text(
        'culture_history_title'.tr(),
        style: AppTextStyles.h2.copyWith(color: Colors.white),
      ),
    );
  }

  Widget _buildJourneyContent(HistoryState state) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: Container(
            // Dynamic height based on number of periods to ensure they all fit
            height: (300 * state.periods.length).h.clamp(1600.h, 5000.h),
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
                      painter: HistoryJourneyPainter(),
                    ),
                    ...state.periods.asMap().entries.map((entry) {
                      return _buildPeriodIsland(
                        entry.key,
                        entry.value,
                        state.periods.length,
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
    // Narrower path to prevent items from bleeding off edges
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

  Widget _buildPeriodIsland(
    int index,
    dynamic period,
    int total,
    double width,
    double height,
    HistoryState state,
  ) {
    final t = 0.1 + (index * 0.8 / (total - 1));
    final path = _buildPath(width, height);
    final metrics = path.computeMetrics().first;
    final pos =
        metrics.getTangentForOffset(metrics.length * t)?.position ??
        Offset.zero;

    // More conservative offsets to keep items within screen bounds
    final bool isLeft = index % 2 == 1;
    final double horizontalOffset = isLeft ? -160.w : 20.w;

    // Wider container (180.w) needs more space for clamping (width - 196.w)
    final double left = (pos.dx + horizontalOffset).clamp(10.w, width - 190.w);

    return Positioned(
      left: left,
      top: pos.dy - 100.h,
      child: GestureDetector(
        onTap: () {
          _avatarController
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
              // Period Node with Image
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

                  // Progress Indicator/Circle Glow
                  if (state.currentPeriod?.id == period.id)
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

              // Era Info
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

class HistoryJourneyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.w
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.w
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final centerX = size.width * 0.5;
    final curveX = size.width * 0.25;

    final path = ui.Path();
    path.moveTo(centerX, 0);
    path.cubicTo(
      centerX + curveX,
      size.height * 0.2,
      centerX - curveX,
      size.height * 0.4,
      centerX,
      size.height * 0.5,
    );
    path.cubicTo(
      centerX + curveX,
      size.height * 0.6,
      centerX - curveX,
      size.height * 0.8,
      centerX,
      size.height * 1.0,
    );

    canvas.drawPath(path, glowPaint);
    canvas.drawPath(path, paint);

    // Trail dots
    final metric = path.computeMetrics().first;
    final dotPaint = Paint()
      ..color = AppColors.accentGold.withValues(alpha: 0.5);
    for (int i = 0; i <= 30; i++) {
      final pos = metric
          .getTangentForOffset(metric.length * (i / 30))
          ?.position;
      if (pos != null) canvas.drawCircle(pos, 2.0.w, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
