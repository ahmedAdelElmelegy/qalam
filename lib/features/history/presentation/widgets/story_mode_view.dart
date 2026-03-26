import 'dart:ui' as ui;
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/features/history/data/models/history_period_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'history_story_app_bar_background.dart';
import 'history_story_content_card.dart';

class StoryModeView extends StatefulWidget {
  final HistoryPeriodModel period;
  final String languageCode;
  final VoidCallback onClose;

  const StoryModeView({
    super.key,
    required this.period,
    required this.languageCode,
    required this.onClose,
  });

  @override
  State<StoryModeView> createState() => _StoryModeViewState();
}

class _StoryModeViewState extends State<StoryModeView> {
  final TtsService _ttsService = TtsService();
  int? _playingIndex;
  String? _playingLang;

  @override
  void initState() {
    super.initState();
    _ttsService.setCompletionHandler(() {
      if (mounted) {
        setState(() {
          _playingIndex = null;
          _playingLang = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  Future<void> _playParagraphAudio(
    String text,
    String langCode,
    int index,
  ) async {
    if (_playingIndex == index && _playingLang == langCode) {
      await _stopAudio();
      return;
    }

    await _ttsService.stop();

    setState(() {
      _playingIndex = index;
      _playingLang = langCode;
    });

    String ttsLang = langCode;
    if (ttsLang == 'ar') {
      ttsLang = 'ar-SA';
    } else if (ttsLang == 'en') {
      ttsLang = 'en-US';
    }

    await _ttsService.speak(text, language: ttsLang);
  }

  Future<void> _stopAudio() async {
    await _ttsService.stop();
    setState(() {
      _playingIndex = null;
      _playingLang = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<String> arabicContent = widget.period.getDetailedDescription(
      'ar',
    );
    final List<String> userLangContent = widget.period.getDetailedDescription(
      widget.languageCode,
    );

    final List<String> arParagraphs = arabicContent.isNotEmpty
        ? arabicContent
        : [widget.period.getDescription('ar')];

    final List<String> userLangParagraphs = userLangContent.isNotEmpty
        ? userLangContent
        : [widget.period.getDescription(widget.languageCode)];

    final int maxLength = arParagraphs.length > userLangParagraphs.length
        ? arParagraphs.length
        : userLangParagraphs.length;

    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 450.h,
            pinned: true,
            stretch: true,
            backgroundColor: Colors.black,
            leading: Padding(
              padding: EdgeInsets.all(8.w),
              child: ClipOval(
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: widget.onClose,
                    ),
                  ),
                ),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
              ],
              title: LayoutBuilder(
                builder: (context, constraints) {
                  final isCollapsed =
                      constraints.maxHeight <=
                      kToolbarHeight + (MediaQuery.of(context).padding.top);
                  return isCollapsed
                      ? Text(
                          widget.period.getTitle('ar'),
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.accentGold,
                            fontFamily: 'NotoKufiArabic',
                          ),
                        ).animate().fadeIn()
                      : const SizedBox.shrink();
                },
              ),
              background: HistoryStoryAppBarBackground(
                period: widget.period,
                languageCode: widget.languageCode,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final arText = index < arParagraphs.length
                    ? arParagraphs[index]
                    : '';
                final userText = index < userLangParagraphs.length
                    ? userLangParagraphs[index]
                    : '';

                return HistoryStoryContentCard(
                  arText: arText,
                  userText: userText,
                  index: index,
                  languageCode: widget.languageCode,
                  playingIndex: _playingIndex,
                  playingLang: _playingLang,
                  onPlayAudio: _playParagraphAudio,
                );
              }, childCount: maxLength),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
        ],
      ),
    );
  }
}
