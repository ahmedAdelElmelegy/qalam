import 'package:flutter/material.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/widgets/video_player_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class VideoThumbnailCard extends StatelessWidget {
  final String videoUrl;
  final String title;

  const VideoThumbnailCard({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VideoPlayerScreen(videoUrl: videoUrl, title: title),
        ),
      ),
      child: Container(
        height: 200.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: AppColors.accentGold.withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentGold.withValues(alpha: 0.15),
              blurRadius: 20,
              spreadRadius: 2,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withValues(alpha: 0.05), Colors.black],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Pulsing glow behind the play button
            Container(
                  width: 90.w,
                  height: 90.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accentGold.withValues(alpha: 0.08),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.3, 1.3),
                  duration: 1500.ms,
                ),

            // Play button circle
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentGold, width: 2),
              ),
              child: Icon(
                Icons.play_arrow_rounded,
                color: AppColors.accentGold,
                size: 44.sp,
              ),
            ),

            // "Tap to watch" label at bottom
            Positioned(
              bottom: 16.h,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.open_in_full_rounded,
                    size: 12.sp,
                    color: Colors.white54,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'Tap to watch in full screen',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 12.sp,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
