import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_tip_card.dart';

class LessonLetterBlockWidget extends StatelessWidget {
  final LetterBlock block;
  final int index;
  final String locale;
  final String? activeSpeakingId;
  final void Function(String, {String? id}) onSpeak;

  const LessonLetterBlockWidget({
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
    final isActive = activeSpeakingId == 'letter_$index';

    final transliteration = localizedValue(
      block.transliterationMap,
      locale,
      defaultValue: block.transliterationMap['en'] ?? '',
    );

    final sound = localizedValue(
      block.soundMap,
      locale,
      defaultValue: block.soundMap['en'] ?? '',
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1E3A6E).withValues(alpha: 0.5),
            const Color(0xFF0D1B3E).withValues(alpha: 0.3),
          ],
        ),
        borderRadius: BorderRadius.circular(28.r),
        border: Border.all(
          color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row: letter big + sound badge + speaker
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Big Arabic letter
              GestureDetector(
                onTap: () => onSpeak(block.arabic, id: 'letter_$index'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 110.w,
                  height: 110.w,
                  decoration: BoxDecoration(
                    color: isActive
                        ? _gold.withValues(alpha: 0.2)
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(24.r),
                    border: Border.all(
                      color: isActive
                          ? _gold
                          : Colors.white.withValues(alpha: 0.15),
                      width: isActive ? 2.5 : 1.5,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        block.arabic,
                        style: AppTextStyles.arabicBody.copyWith(
                          color: Colors.white,
                          fontSize: 58.sp,
                          height: 1.2,
                        ),
                      ),
                      Positioned(
                        bottom: 8.h,
                        right: 8.w,
                        child: Container(
                          padding: EdgeInsets.all(5.w),
                          decoration: BoxDecoration(
                            color: isActive
                                ? _gold
                                : _gold.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.volume_up_rounded,
                            color: isActive ? Colors.black : _gold,
                            size: 14.w,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 20.w),
              // Info column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transliteration,
                      style: AppTextStyles.h3.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 26.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    if (sound.isNotEmpty)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: const Color(0xFF3B82F6).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '/$sound/',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: const Color(0xFF93C5FD),
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),

          // Forms table
          if (block.forms != null) ...[
            SizedBox(height: 20.h),
            _buildFormsTable(block.forms!),
          ],

          // Tip
          if (block.tip.isNotEmpty) ...[
            SizedBox(height: 16.h),
            LessonTipCard(
              tip: block.tip[locale] ?? block.tip['en'] ?? '',
            ),
          ],
        ],
      ),
    )
    .animate()
    .fadeIn(delay: Duration(milliseconds: 100 + index * 60))
    .slideY(begin: 0.08, end: 0, duration: 400.ms);
  }

  Widget _buildFormsTable(LetterForms forms) {
    final cells = [
      ('Isolated', forms.isolated),
      ('Initial', forms.initial),
      ('Medial', forms.medial),
      ('Final', forms.finalForm),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Row(
        children: cells.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value.$1;
          final char = entry.value.$2;
          return Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: i < 3
                      ? BorderSide(color: Colors.white.withValues(alpha: 0.08))
                      : BorderSide.none,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              child: Column(
                children: [
                  Text(
                    char,
                    style: AppTextStyles.arabicBody.copyWith(
                      color: Colors.white,
                      fontSize: 26.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white38,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
