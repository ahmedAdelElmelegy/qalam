import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:arabic/features/curriculum/presentation/view/screens/quiz_screen.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';

class LessonContentScreen extends StatefulWidget {
  final Lesson lesson;
  final String levelId;
  final String unitId;

  const LessonContentScreen({
    super.key,
    required this.lesson,
    required this.levelId,
    required this.unitId,
  });

  @override
  State<LessonContentScreen> createState() => _LessonContentScreenState();
}

class _LessonContentScreenState extends State<LessonContentScreen> {
  final TtsService _ttsService = TtsService();
  bool isSpeaking = false;
  String? _speakingId; // track which block is speaking

  static const _gold = Color(0xFFD4AF37);
  static const _goldLight = Color(0xFFFFE066);
  static const _bg = Color(0xFF080818);

  @override
  void initState() {
    super.initState();
    _initTts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.lesson.dbId != null) {
        context.read<QuizCubit>().getLessonQuiz(
              lang: context.locale.languageCode,
              lessonId: widget.lesson.dbId!,
            );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.lesson.dbId != null) {
      context.read<QuizCubit>().getLessonQuiz(
            lang: context.locale.languageCode,
            lessonId: widget.lesson.dbId!,
          );
    }
  }

  Future<void> _initTts() async {
    try {
      await _ttsService.initialize();
      await _ttsService.updateSpeed(0.4);
      _ttsService.setStartHandler(() {
        if (mounted) setState(() => isSpeaking = true);
      });
      _ttsService.setCompletionHandler(() {
        if (mounted) {
          setState(() {
            isSpeaking = false;
            _speakingId = null;
          });
        }
      });
      _ttsService.setErrorHandler((msg) {
        if (mounted) {
          setState(() {
            isSpeaking = false;
            _speakingId = null;
          });
        }
      });
    } catch (e) {
      debugPrint('TTS init error: $e');
    }
  }

  @override
  void dispose() {
    _ttsService.clearHandlers();
    super.dispose();
  }

  Future<void> _speak(
    String text, {
    String language = 'ar-SA',
    String? id,
  }) async {
    if (text.isEmpty) return;
    setState(() => _speakingId = id);
    await _ttsService.speak(text, language: language);
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final title =
        widget.lesson.titleTranslations[locale] ??
        widget.lesson.translations[locale] ??
        widget.lesson.title;
    final explanation =
        widget.lesson.explanationTranslations[locale] ?? widget.lesson.content;

    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context, title),
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        return SingleChildScrollView(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 16.h,
                          ),
                          child: Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: isWide ? 1000 : 600,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildTypeBadge(),
                                  SizedBox(height: 20.h),

                                  // Explanation card
                                  if (explanation.isNotEmpty) ...[
                                    _buildExplanationCard(explanation),
                                    SizedBox(height: 24.h),
                                  ],

                                  // Content blocks
                                  if (isWide)
                                    _buildWideContentGrid(locale)
                                  else
                                    ..._buildContentBlocks(locale),

                                  SizedBox(height: 60.h),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Content Block Dispatcher ─────────────────────────────────────────────

  List<Widget> _buildContentBlocks(String locale) {
    final blocks = widget.lesson.contentBlocks;
    if (blocks.isEmpty) return [];

    final widgets = <Widget>[];
    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i];
      widgets.add(_buildBlockWidget(block, i, locale));
      widgets.add(SizedBox(height: 16.h));
    }
    return widgets;
  }

  Widget _buildBlockWidget(ContentBlock block, int index, String locale) {
    switch (block.type) {
      case ContentBlockType.letter:
        return _buildLetterBlock(block as LetterBlock, index, locale);
      case ContentBlockType.word:
        return _buildWordBlock(block as WordBlock, index, locale);
      case ContentBlockType.sentence:
        return _buildSentenceBlock(block as SentenceBlock, index, locale);
    }
  }

  Widget _buildWideContentGrid(String locale) {
    final blocks = widget.lesson.contentBlocks;
    if (blocks.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20.w,
        mainAxisSpacing: 20.h,
        mainAxisExtent: 220.h, // Fixed height for consistency in grid
      ),
      itemCount: blocks.length,
      itemBuilder: (context, index) {
        return _buildBlockWidget(blocks[index], index, locale);
      },
    );
  }

  // ─── Letter Block ─────────────────────────────────────────────────────────

  Widget _buildLetterBlock(LetterBlock block, int index, String locale) {
    final isActive = _speakingId == 'letter_$index';

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
                    onTap: () => _speak(block.arabic, id: 'letter_$index'),
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
                              color: const Color(
                                0xFF3B82F6,
                              ).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(
                                color: const Color(
                                  0xFF3B82F6,
                                ).withValues(alpha: 0.4),
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
                _buildTipCard(
                  block.tip[context.locale.languageCode] ??
                      block.tip['en'] ??
                      '',
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

  // ─── Word Block ───────────────────────────────────────────────────────────

  Widget _buildWordBlock(WordBlock block, int index, String locale) {
    final isActive = _speakingId == 'word_$index';
    final translation =
        block.translation[locale] ?? block.translation['en'] ?? '';

    final transliteration = localizedValue(
      block.transliterationMap,
      locale,
      defaultValue: block.transliterationMap['en'] ?? '',
    );

    return GestureDetector(
          onTap: () => _speak(block.arabic, id: 'word_$index'),
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
                    _buildHighlightedArabic(
                      block.arabic,
                      block.highlightLetter,
                    ),
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

  // ─── Sentence Block ───────────────────────────────────────────────────────

  Widget _buildSentenceBlock(SentenceBlock block, int index, String locale) {
    final isActive = _speakingId == 'sentence_$index';
    final translation =
        block.translation[locale] ?? block.translation['en'] ?? '';
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
                          onTap: () =>
                              _speak(block.arabic, id: 'sentence_$index'),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: isActive
                                  ? _gold
                                  : _gold.withValues(alpha: 0.12),
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
                      _buildTipCard(tip),
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

  Widget _buildBreakdownChips(
    List<SentenceBreakdown> breakdown,
    String locale,
  ) {
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

  // ─── Shared UI pieces ─────────────────────────────────────────────────────

  Widget _buildTipCard(String tip) {
    if (tip.isEmpty) return const SizedBox.shrink();
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: _gold.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: _gold.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb_outline_rounded, color: _gold, size: 16.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              tip,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white70,
                fontSize: 13.sp,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExplanationCard(String text) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lesson Overview',
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white38,
              fontSize: 11.sp,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.6,
              fontSize: 15.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.07),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
              ),
              child: const Icon(
                Icons.close_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.h4.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          SizedBox(width: 8.w),
          // XP badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: _gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: _gold.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star_rounded, color: _gold, size: 14.w),
                SizedBox(width: 4.w),
                Text(
                  '+${widget.lesson.xpReward} XP',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _gold,
                    fontWeight: FontWeight.w700,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: _getTypeColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: _getTypeColor().withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getTypeIcon(), color: _getTypeColor(), size: 16.w),
          SizedBox(width: 8.w),
          Text(
            widget.lesson.type.toUpperCase(),
            style: AppTextStyles.bodySmall.copyWith(
              color: _getTypeColor(),
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              fontSize: 12.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Icon(
            Icons.timer_outlined,
            color: _getTypeColor().withValues(alpha: 0.7),
            size: 13.w,
          ),
          SizedBox(width: 4.w),
          Text(
            '${widget.lesson.estimatedMinutes} min',
            style: AppTextStyles.bodySmall.copyWith(
              color: _getTypeColor().withValues(alpha: 0.7),
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
    ).animate().fadeIn().scale();
  }

  Widget _buildFooter(BuildContext context) {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, quizState) {
        quizState is QuizLoading;
        Quiz? fetchedQuiz;
        if (quizState is QuizSucess &&
            quizState.quiz.id == widget.lesson.dbId) {
          fetchedQuiz = quizState.quiz.toDomain();
        }

        final quizToPass = fetchedQuiz ?? widget.lesson.quiz;
        final hasQuiz = quizToPass != null && quizToPass.questions.isNotEmpty;

        // If we have a dbId but no quiz yet and still initial/loading, we should wait
        final isWaitingForQuiz =
            widget.lesson.dbId != null &&
            !hasQuiz &&
            (quizState is QuizInitial || quizState is QuizLoading);

        return Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 36.h),
              child: GestureDetector(
                onTap: isWaitingForQuiz
                    ? null
                    : () {
                        if (hasQuiz || widget.lesson.dbId != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => QuizScreen(
                                quiz: quizToPass,
                                quizLessonId: widget.lesson.dbId,
                                lessonId: widget.lesson.id,
                                levelId: widget.levelId,
                                unitId: widget.unitId,
                              ),
                            ),
                          );
                        } else {
                          final nextNav = context
                              .read<CurriculumCubit>()
                              .getNextNavigation(
                                widget.levelId,
                                widget.unitId,
                                widget.lesson.id,
                              );
                          final nextItem = nextNav?['item'];

                          context.read<CurriculumCubit>().completeLesson(
                            widget.levelId,
                            widget.unitId,
                            widget.lesson.id,
                          );
                          Navigator.pop(context);

                          if (nextItem != null) {
                            if (nextItem is Lesson) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LessonContentScreen(
                                    lesson: nextItem,
                                    levelId: nextNav!['levelId'],
                                    unitId: nextNav['unitId'],
                                  ),
                                ),
                              );
                            } else if (nextItem is Quiz) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => QuizScreen(
                                    quiz: nextItem,
                                    levelId: nextNav!['levelId'],
                                    unitId: nextNav['unitId'],
                                  ),
                                ),
                              );
                            }
                          }
                        }
                      },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isWaitingForQuiz
                          ? [Colors.grey.shade400, Colors.grey.shade300]
                          : [_gold, _goldLight],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(
                        color: (isWaitingForQuiz ? Colors.grey : _gold)
                            .withValues(alpha: 0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: isWaitingForQuiz
                        ? SizedBox(
                            height: 24.h,
                            width: 24.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                const Color(0xFF1A1A2E).withValues(alpha: 0.5),
                              ),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                hasQuiz
                                    ? Icons.quiz_rounded
                                    : Icons.check_circle_rounded,
                                color: const Color(0xFF1A1A2E),
                                size: 22.w,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                hasQuiz
                                    ? 'Take Lesson Quiz'
                                    : 'Complete & Continue',
                                style: AppTextStyles.h4.copyWith(
                                  color: const Color(0xFF1A1A2E),
                                  fontWeight: FontWeight.w900,
                                  fontSize: 17.sp,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(delay: 600.ms)
            .scale(begin: const Offset(0.95, 0.95));
      },
    );
  }

  // ─── Type helpers ─────────────────────────────────────────────────────────

  Color _getTypeColor() {
    switch (widget.lesson.type) {
      case 'alphabet':
        return const Color(0xFF3B82F6);
      case 'vocabulary':
        return const Color(0xFF10B981);
      case 'grammar':
        return const Color(0xFF8B5CF6);
      case 'review':
        return const Color(0xFFD4AF37);
      case 'listening':
        return const Color(0xFFEC4899);
      default:
        return Colors.white;
    }
  }

  IconData _getTypeIcon() {
    switch (widget.lesson.type) {
      case 'alphabet':
        return Icons.abc_rounded;
      case 'vocabulary':
        return Icons.translate_rounded;
      case 'grammar':
        return Icons.architecture_rounded;
      case 'review':
        return Icons.refresh_rounded;
      case 'listening':
        return Icons.headset_rounded;
      default:
        return Icons.book_rounded;
    }
  }
}
