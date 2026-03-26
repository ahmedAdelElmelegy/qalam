import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_tip_card.dart';

class LessonSentenceBlockWidget extends StatelessWidget {
  final SentenceBlock block;
  final int index;
  final String locale;
  final String? activeSpeakingId;
  final void Function(String, {String? id}) onSpeak;

  const LessonSentenceBlockWidget({
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
    final isActive = activeSpeakingId == 'sentence_$index';
    final translation = block.translation[locale] ?? block.translation['en'] ?? '';
    final tip = block.tip[locale] ?? block.tip['en'] ?? '';

    final transliteration = localizedValue(
      block.transliterationMap,
      locale,
      defaultValue: block.transliterationMap['en'] ?? '',
    );

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1A1A2E).withValues(alpha: 0.8),
            const Color(0xFF16213E).withValues(alpha: 0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(color: _gold.withValues(alpha: 0.2), width: 1.5),
      ),
      child: Column(
        children: [
          // Header bar
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28.r),
                topRight: Radius.circular(28.r),
              ),
              border: Border(
                bottom: BorderSide(color: _gold.withValues(alpha: 0.15)),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.format_quote_rounded, color: _gold, size: 16.w),
                SizedBox(width: 8.w),
                Text(
                  'Example Sentence',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _gold,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Arabic sentence + speaker
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        block.arabic,
                        textAlign: TextAlign.right,
                        style: AppTextStyles.arabicBody.copyWith(
                          color: Colors.white,
                          fontSize: 24.sp,
                          height: 1.6,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    GestureDetector(
                      onTap: () => onSpeak(block.arabic, id: 'sentence_$index'),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: isActive ? _gold : _gold.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.volume_up_rounded,
                          color: isActive ? Colors.black : _gold,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                // Transliteration
                if (transliteration.isNotEmpty)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      transliteration,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: _gold.withValues(alpha: 0.7),
                        fontStyle: FontStyle.italic,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),

                // Translation
                if (translation.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  Container(
                    height: 1,
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    translation,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 16.sp,
                      height: 1.5,
                    ),
                  ),
                ],

                // Breakdown chips
                if (block.breakdown.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  _buildBreakdownChips(block.breakdown, locale),
                ],

                // Tip
                if (tip.isNotEmpty) ...[
                  SizedBox(height: 16.h),
                  LessonTipCard(tip: tip),
                ],
              ],
            ),
          ),
        ],
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: 100 + index * 60))
    .slideY(begin: 0.08, end: 0, duration: 400.ms);
  }

  Widget _buildBreakdownChips(List<SentenceBreakdown> breakdown, String locale) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      alignment: WrapAlignment.end,
      children: breakdown.map((b) {
        final meaning = b.meaning[locale] ?? b.meaning['en'] ?? '';
        return Tooltip(
          message: meaning,
          preferBelow: true,
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: _gold.withValues(alpha: 0.3)),
          ),
          textStyle: AppTextStyles.bodySmall.copyWith(
            color: Colors.white,
            fontSize: 12.sp,
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  b.word,
                  style: AppTextStyles.arabicBody.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  meaning,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white54,
                    fontSize: 10.sp,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
