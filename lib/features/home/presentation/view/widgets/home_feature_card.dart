import 'dart:ui';
import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FeatureData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget route;

  FeatureData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
  });
}

class HomeFeatureCard extends StatefulWidget {
  final FeatureData data;
  final int index;

  const HomeFeatureCard({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<HomeFeatureCard> createState() => _HomeFeatureCardState();
}

class _HomeFeatureCardState extends State<HomeFeatureCard>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _breathController;

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000 + widget.index * 200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _breathController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _breathController,
      builder: (context, child) {
        final breathScale = 1.0 + (_breathController.value * 0.02);

        return GestureDetector(
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapUp: (_) {
            setState(() => _isPressed = false);
            context.push(widget.data.route);
          },
          onTapCancel: () => setState(() => _isPressed = false),
          child: Transform.scale(
            scale: _isPressed ? 0.92 : breathScale,
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001) // perspective
                ..rotateX(_isPressed ? -0.05 : 0)
                ..rotateY(_isPressed ? 0.05 : 0),
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: widget.data.color.withValues(
                        alpha: _isPressed ? 0.3 : 0.2,
                      ),
                      blurRadius: _isPressed ? 25 : 20,
                      offset: Offset(0, _isPressed ? 6 : 8),
                      spreadRadius: _isPressed ? 0 : 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            widget.data.color.withValues(alpha: 0.25),
                            widget.data.color.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: widget.data.color.withValues(alpha: 0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: -20,
                            right: -20,
                            child: Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.data.color.withValues(
                                  alpha: 0.15,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.data.color.withValues(
                                      alpha: 0.2,
                                    ),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(20.w),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80.w,
                                  height: 80.w,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        widget.data.color,
                                        widget.data.color.withValues(
                                          alpha: 0.7,
                                        ),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: widget.data.color.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 15,
                                        offset: const Offset(0, 6),
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: Colors.white.withValues(
                                          alpha: 0.3,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(-2, -2),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    widget.data.icon,
                                    color: Colors.white,
                                    size: 38.w,
                                  )
                                      .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(),
                                      )
                                      .shimmer(
                                        duration: 2.seconds,
                                        color: Colors.white.withValues(
                                          alpha: 0.4,
                                        ),
                                      )
                                      .moveY(
                                        begin: -3,
                                        end: 3,
                                        duration: 1.5.seconds,
                                        curve: Curves.easeInOut,
                                      ),
                                ),
                                SizedBox(height: 16.h),
                                FittedBox(
                                  child: Text(
                                    widget.data.title,
                                    style: AppTextStyles.h4.copyWith(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.3,
                                          ),
                                          offset: const Offset(0, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                FittedBox(
                                  child: Text(
                                    widget.data.subtitle,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      fontSize: 12.sp,
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
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
          ),
        )
            .animate()
            .fadeIn(delay: (400 + widget.index * 100).ms, duration: 400.ms)
            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuart)
            .scale(begin: const Offset(0.9, 0.9), curve: Curves.easeOutBack);
      },
    );
  }
}
