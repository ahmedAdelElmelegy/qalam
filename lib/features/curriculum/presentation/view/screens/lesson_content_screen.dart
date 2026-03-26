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
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_explanation_card.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_letter_block.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_word_block.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_sentence_block.dart';

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
                                    LessonExplanationCard(text: explanation),
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
        return LessonLetterBlockWidget(
          block: block as LetterBlock,
          index: index,
          locale: locale,
          activeSpeakingId: _speakingId,
          onSpeak: _speak,
        );
      case ContentBlockType.word:
        return LessonWordBlockWidget(
          block: block as WordBlock,
          index: index,
          locale: locale,
          activeSpeakingId: _speakingId,
          onSpeak: _speak,
        );
      case ContentBlockType.sentence:
        return LessonSentenceBlockWidget(
          block: block as SentenceBlock,
          index: index,
          locale: locale,
          activeSpeakingId: _speakingId,
          onSpeak: _speak,
        );
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