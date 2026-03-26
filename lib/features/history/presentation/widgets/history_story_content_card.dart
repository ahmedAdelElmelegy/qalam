import 'dart:ui' as ui;
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HistoryStoryContentCard extends StatelessWidget {
  final String arText;
  final String userText;
  final int index;
  final String languageCode;
  final int? playingIndex;
  final String? playingLang;
  final void Function(String text, String langCode, int index) onPlayAudio;

  const HistoryStoryContentCard({
    super.key,
    required this.arText,
    required this.userText,
    required this.index,
    required this.languageCode,
    required this.playingIndex,
    required this.playingLang,
    required this.onPlayAudio,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.08),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (arText.isNotEmpty)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildAudioTrigger(
                          langCode: 'ar',
                          index: index,
                          onTap: () => onPlayAudio(arText, 'ar', index),
                        ),
                        SizedBox(width: 20.w),
                        Expanded(
                          child: Text(
                            arText,
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.95),
                              height: 2.2,
                              fontSize: 19.sp,
                              fontFamily: 'NotoKufiArabic',
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (arText.isNotEmpty &&
                      userText.isNotEmpty &&
                      languageCode != 'ar')
                    _buildEtchedDivider(),
                  if (userText.isNotEmpty && languageCode != 'ar')
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            userText,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.8,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w300,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                        SizedBox(width: 20.w),
                        _buildAudioTrigger(
                          langCode: languageCode,
                          index: index,
                          onTap: () =>
                              onPlayAudio(userText, languageCode, index),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: (100 * index).ms, duration: 800.ms).slideY(
            begin: 0.1,
            end: 0,
          ),
    );
  }

  Widget _buildEtchedDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Container(
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0),
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAudioTrigger({
    required String langCode,
    required int index,
    required VoidCallback onTap,
  }) {
    final isPlaying = playingIndex == index && playingLang == langCode;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: isPlaying
              ? AppColors.accentGold
              : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: Border.all(
            color: isPlaying
                ? Colors.white
                : AppColors.accentGold.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(
          isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
          color: isPlaying ? AppColors.primaryDark : AppColors.accentGold,
          size: 20.w,
        ),
      ),
    );
  }
}
