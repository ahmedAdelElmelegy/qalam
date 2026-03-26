import 'package:arabic/features/curriculum/data/models/culture_model.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/view/widgets/lesson_explanation_card.dart';

import '../widgets/lesson_content_blocks_builder.dart';
import '../widgets/lesson_footer_widget.dart';
import '../widgets/lesson_header_widget.dart';
import '../widgets/lesson_type_badge.dart';

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
                  LessonHeaderWidget(
                    title: title,
                    xpReward: widget.lesson.xpReward,
                  ),
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
                                  LessonTypeBadge(
                                    type: widget.lesson.type,
                                    estimatedMinutes:
                                        widget.lesson.estimatedMinutes,
                                  ),
                                  SizedBox(height: 20.h),
                                  if (explanation.isNotEmpty) ...[
                                    LessonExplanationCard(text: explanation),
                                    SizedBox(height: 24.h),
                                  ],
                                  LessonContentBlocksBuilder(
                                    blocks: widget.lesson.contentBlocks,
                                    locale: locale,
                                    activeSpeakingId: _speakingId,
                                    onSpeak: _speak,
                                    isWide: isWide,
                                  ),
                                  SizedBox(height: 60.h),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  LessonFooterWidget(
                    lesson: widget.lesson,
                    levelId: widget.levelId,
                    unitId: widget.unitId,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}