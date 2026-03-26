import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';

class LessonWordBlockWidget extends StatelessWidget {
  final WordBlock block;
  final int index;
  final String locale;
  final String? activeSpeakingId;
  final void Function(String, {String? id}) onSpeak;

  const LessonWordBlockWidget({
    super.key,
    required this.block,
    required this.index,
    required this.locale,
    required this.activeSpeakingId,
    required this.onSpeak,
  });

  static const _gold = Color(0xFFD4AF37);

  @override
  Widget build(BuildContext context) {
    final isActive = activeSpeakingId == 'word_$index';
    final translation = block.translation[locale] ?? block.translation['en'] ?? '';

    final transliteration = localizedValue(
      block.transliterationMap,
      locale,
      defaultValue: block.transliterationMap['en'] ?? '',
    );

    return GestureDetector(
      onTap: () => onSpeak(block.arabic, id: 'word_$index'),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.08)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(24.r),
          border: Border.all(
            color: isActive
                ? _gold.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.08),
            width: isActive ? 1.5 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Left: translation info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.translate_rounded,
                        color: Colors.white38,
                        size: 14.w,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'Word',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white38,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  if (translation.isNotEmpty)
                    Text(
                      translation,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                        fontSize: 18.sp,
                      ),
                    ),
                  SizedBox(height: 6.h),
                  Text(
                    transliteration,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: _gold.withValues(alpha: 0.7),
                      fontStyle: FontStyle.italic,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 16.w),
            // Right: Arabic word + speaker
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildHighlightedArabic(block.arabic, block.highlightLetter),
                SizedBox(height: 8.h),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: isActive ? _gold : _gold.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.volume_up_rounded,
                    color: isActive ? Colors.black : _gold,
                    size: 18.w,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: 100 + index * 60))
    .slideX(begin: 0.05, end: 0, duration: 350.ms);
  }

  Widget _buildHighlightedArabic(String arabic, String? highlightLetter) {
    if (highlightLetter == null || highlightLetter.isEmpty) {
      return Text(
        arabic,
        style: AppTextStyles.arabicBody.copyWith(
          color: Colors.white,
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    // Split on the highlight letter and reconstruct with a colored span
    final parts = arabic.split(highlightLetter);
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        spans.add(TextSpan(text: parts[i]));
      }
      if (i < parts.length - 1) {
        spans.add(
          TextSpan(
            text: highlightLetter,
            style: const TextStyle(color: _gold, fontWeight: FontWeight.w900),
          ),
        );
      }
    }

    return Text.rich(
      TextSpan(
        style: AppTextStyles.arabicBody.copyWith(
          color: Colors.white,
          fontSize: 32.sp,
          fontWeight: FontWeight.w700,
        ),
        children: spans,
      ),
    );
  }
}
