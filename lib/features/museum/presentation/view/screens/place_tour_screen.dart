import 'dart:ui';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arabic/core/widgets/custom_loading_widget.dart';
import '../../../../../core/services/tts_service.dart';
import '../../manager/add by ai/museum_cubit.dart';
import '../../manager/add by ai/museum_state.dart';
import '../../../data/models/museum_object_model.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/object_details_sheet.dart';

class PlaceTourScreen extends StatefulWidget {
  const PlaceTourScreen({super.key});

  @override
  State<PlaceTourScreen> createState() => _PlaceTourScreenState();
}

class _PlaceTourScreenState extends State<PlaceTourScreen> {
  final TransformationController _transformationController =
      TransformationController();
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _ttsService.initialize();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  void _showObjectDetails(MuseumObjectModel object) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ObjectDetailsSheet(
        object: object,
        onPlayArabic: () =>
            _ttsService.speak(object.arabicSentence, language: 'ar-SA'),
        onPlayEnglish: () =>
            _ttsService.speak(object.englishSentence, language: 'en-US'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MuseumCubit, MuseumState>(
      builder: (context, state) {
        if (state is MuseumLoaded && state.selectedPlace != null) {
          final place = state.selectedPlace!;

          return Scaffold(
            backgroundColor: AppColors.primaryNavy,
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Padding(
                padding: EdgeInsets.all(8.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: BackButton(color: Colors.white),
                    ),
                  ),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIRTUAL TOUR',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.accentGold,
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    place.name,
                    style: AppTextStyles.h3.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
            body: Stack(
              children: [
                // Interactive Environment
                InteractiveViewer(
                  transformationController: _transformationController,
                  maxScale: 3.0,
                  minScale: 1.0,
                  child: Stack(
                    children: [
                      // High-Res Background
                      place.imageUrl.startsWith('http')
                          ? CachedNetworkImage(
                              imageUrl: place.imageUrl,
                              width: 1.sw,
                              height: 1.sh,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              place.imageUrl,
                              width: 1.sw,
                              height: 1.sh,
                              fit: BoxFit.fill,
                            ),

                      // Hotspots mapping positionX/Y to Screen
                      ...place.objects.map(
                        (obj) => Positioned(
                          left: obj.positionX * 1.sw,
                          top: obj.positionY * 1.sh,
                          child: _buildHotspot(obj),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scanner Overlay (Visual Polish)
                _buildScannerOverlay(),

                // Bottom Instruction Bar
                Positioned(
                  bottom: 40.h,
                  left: 24.w,
                  right: 24.w,
                  child:
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                              vertical: 16.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.touch_app_rounded,
                                  color: AppColors.accentGold,
                                  size: 24.w,
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    'Tap the glowing points to discover Arabic vocabulary and objects.',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white,
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().slideY(
                        begin: 1,
                        end: 0,
                        duration: 600.ms,
                        curve: Curves.easeOutBack,
                      ),
                ),
              ],
            ),
          );
        }
        return const CustomLoadingWidget();
      },
    );
  }

  Widget _buildHotspot(MuseumObjectModel obj) {
    return GestureDetector(
      onTap: () => _showObjectDetails(obj),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Multi-layered Pulse Aura
          _buildPulseAura(20.w, AppColors.accentGold.withValues(alpha: 0.3)),
          _buildPulseAura(40.w, AppColors.accentGold.withValues(alpha: 0.15)),

          // Core High-Intensity Point
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold,
                  blurRadius: 15,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 4,
                  spreadRadius: 1,
                ),
              ],
            ),
          )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.2, 1.2),
                duration: 1.seconds,
                curve: Curves.easeInOut,
              ),

          // Glassmorphic Name Label
          Positioned(
            top: -45.h,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        obj.localizedNames[context.locale.languageCode] ??
                            obj.arabicName,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.sp,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
                // Tiny Connector
                CustomPaint(
                  size: Size(10.w, 6.h),
                  painter: _TrianglePainter(
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildPulseAura(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2),
      ),
    )
        .animate(onPlay: (controller) => controller.repeat())
        .scale(
          begin: const Offset(1, 1),
          end: const Offset(3.5, 3.5),
          duration: 2.5.seconds,
          curve: Curves.easeOutCubic,
        )
        .fadeOut(duration: 2.5.seconds);
  }
  Widget _buildScannerOverlay() {
    return IgnorePointer(
      child: Column(
        children: [
          const Spacer(),
          Container(
                height: 2.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentGold.withValues(alpha: 0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              )
              .animate(onPlay: (controller) => controller.repeat())
              .moveY(
                begin: 0,
                end: -1.sh,
                duration: 5.seconds,
                curve: Curves.linear,
              ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
