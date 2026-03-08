import 'dart:ui' as ui;
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/custom_video_player.dart';
import 'package:arabic/features/clothing/data/models/clothing_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'clothing_image.dart';

class ClothingStoryView extends StatefulWidget {
  final ClothingModel clothing;
  final String languageCode;
  final VoidCallback onClose;

  const ClothingStoryView({
    super.key,
    required this.clothing,
    required this.languageCode,
    required this.onClose,
  });

  @override
  State<ClothingStoryView> createState() => _ClothingStoryViewState();
}

class _ClothingStoryViewState extends State<ClothingStoryView> {
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
    final List<String> arabicContent = widget.clothing.getDetails('ar');
    final List<String> userLangContent = widget.clothing.getDetails(
      widget.languageCode,
    );

    final List<String> arParagraphs = arabicContent.isNotEmpty
        ? arabicContent
        : [widget.clothing.getDescription('ar')];

    final List<String> userLangParagraphs = userLangContent.isNotEmpty
        ? userLangContent
        : [widget.clothing.getDescription(widget.languageCode)];

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
                          widget.clothing.getTitle('ar'),
                          style: AppTextStyles.h3.copyWith(
                            color: AppColors.accentGold,
                            fontFamily: 'NotoKufiArabic',
                          ),
                        ).animate().fadeIn()
                      : const SizedBox.shrink();
                },
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (widget.clothing.gallery.isNotEmpty)
                    ClothingImage(
                          imagePath: widget.clothing.gallery.first,
                          fit: BoxFit.cover,
                        )
                        .animate(onPlay: (c) => c.repeat(reverse: true))
                        .scale(
                          begin: const Offset(1.0, 1.0),
                          end: const Offset(1.1, 1.1),
                          duration: 15.seconds,
                        ),

                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.8),
                            Colors.black,
                          ],
                          stops: const [0.0, 0.4, 0.8, 1.0],
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 40.h,
                    left: 24.w,
                    right: 24.w,
                    child: Column(
                      crossAxisAlignment: widget.languageCode == 'ar'
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.clothing.getTitle('ar'),
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: AppTextStyles.displayMedium.copyWith(
                            color: AppColors.accentGold,
                            fontSize: 34.sp,
                            fontFamily: 'NotoKufiArabic',
                            fontWeight: FontWeight.bold,
                            shadows: [
                              const Shadow(color: Colors.black, blurRadius: 20),
                            ],
                          ),
                        ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),

                        if (widget.languageCode != 'ar') ...[
                          SizedBox(height: 8.h),
                          Text(
                            widget.clothing.getTitle(widget.languageCode),
                            style: AppTextStyles.h2.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.w200,
                              shadows: [
                                const Shadow(
                                  color: Colors.black,
                                  blurRadius: 20,
                                ),
                              ],
                            ),
                          ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.2),
                        ],
                      ],
                    ),
                  ),
                ],
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

                return _buildContentCard(arText, userText, index);
              }, childCount: maxLength),
            ),
          ),

          if (widget.clothing.videoIdea.isNotEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: widget.clothing.videoIdea.startsWith('http')
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Featured Video',
                            style: AppTextStyles.h4.copyWith(
                              color: AppColors.accentGold,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          CustomVideoPlayer(
                            videoUrl: widget.clothing.videoIdea,
                          ),
                        ],
                      )
                    : Container(
                        padding: EdgeInsets.all(20.w),
                        decoration: BoxDecoration(
                          color: AppColors.accentGold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.accentGold.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.video_library_rounded,
                                  color: AppColors.accentGold,
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  'Video Concept',
                                  style: AppTextStyles.h4.copyWith(
                                    color: AppColors.accentGold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              widget.clothing.videoIdea,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
        ],
      ),
    );
  }

  Widget _buildContentCard(String arText, String userText, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child:
          Container(
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
                                  onTap: () =>
                                      _playParagraphAudio(arText, 'ar', index),
                                ),
                                SizedBox(width: 20.w),
                                Expanded(
                                  child: Text(
                                    arText,
                                    textAlign: TextAlign.right,
                                    textDirection: TextDirection.rtl,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.95,
                                      ),
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
                              widget.languageCode != 'ar')
                            _buildEtchedDivider(),

                          if (userText.isNotEmpty &&
                              widget.languageCode != 'ar')
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    userText,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: Colors.white.withValues(
                                        alpha: 0.7,
                                      ),
                                      height: 1.8,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w300,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20.w),
                                _buildAudioTrigger(
                                  langCode: widget.languageCode,
                                  index: index,
                                  onTap: () => _playParagraphAudio(
                                    userText,
                                    widget.languageCode,
                                    index,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .animate()
              .fadeIn(delay: (100 * index).ms, duration: 800.ms)
              .slideY(begin: 0.1, end: 0),
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
    final isPlaying = _playingIndex == index && _playingLang == langCode;

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
