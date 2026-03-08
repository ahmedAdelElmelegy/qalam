import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/network_checker.dart';
import 'package:arabic/features/voice_translator/data/services/mlkit_translation_service.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_cubit.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:arabic/features/home/presentation/view/widgets/bg_3d.dart';
import 'package:arabic/features/home/presentation/view/widgets/home_bg.dart';

class VoiceTranslatorScreen extends StatelessWidget {
  const VoiceTranslatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VoiceTranslatorCubit(
        translationService: MlKitTranslationService(),
        ttsService: TtsService(),
      ),
      child: const _VoiceTranslatorView(),
    );
  }
}

class _VoiceTranslatorView extends StatelessWidget {
  const _VoiceTranslatorView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080818),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'voice_translator_title'.tr(context: context),
          style: AppTextStyles.displayMedium.copyWith(
            color: Colors.white,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          const Positioned.fill(child: Background3D()),
          HomeBackground(
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child:
                        BlocBuilder<VoiceTranslatorCubit, VoiceTranslatorState>(
                          builder: (context, state) {
                            return ListView(
                              padding: EdgeInsets.symmetric(
                                horizontal: 24.w,
                                vertical: 16.h,
                              ),
                              children: [
                                // Language Selector
                                _buildLanguageSelector(context, state),

                                SizedBox(height: 16.h),

                                // User Input Area
                                _buildInputCard(context, state),

                                SizedBox(height: 24.h),

                                // AI Response Area
                                _buildResponseCard(context, state),
                              ],
                            );
                          },
                        ),
                  ),

                  // Microphone Controls
                  _buildMicControls(context),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(BuildContext context, VoiceTranslatorState state) {
    String text = 'tap_microphone'.tr(context: context);
    bool isListening = false;

    if (state is VoiceTranslatorListening) {
      text = state.partialText.isEmpty
          ? 'listening'.tr(context: context)
          : state.partialText;
      isListening = true;
    } else if (state is VoiceTranslatorNoMatch) {
      text = '...';
    } else if (state is VoiceTranslatorTranslating) {
      text = state.originalText;
    } else if (state is VoiceTranslatorSuccess) {
      text = state.userSpeech;
    } else if (state is VoiceTranslatorError && state.originalText.isNotEmpty) {
      text = state.originalText;
    } else if (state is VoiceTranslatorError && state.originalText.isEmpty) {
      text = state.error;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isListening
              ? const Color(0xFFD4AF37)
              : Colors.white.withValues(alpha: 0.1),
          width: 1.5,
        ),
        boxShadow: isListening
            ? [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withValues(alpha: 0.2),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_outline,
                color: const Color(0xFFD4AF37),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'you_said'.tr(context: context),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFFD4AF37),
                  letterSpacing: 1.2,
                ),
              ),
              const Spacer(),
              if (isListening)
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Color(0xFFD4AF37),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            text,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 18.sp,
              color:
                  isListening &&
                      state is VoiceTranslatorListening &&
                      state.partialText.isEmpty
                  ? Colors.white54
                  : Colors.white,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(
    BuildContext context,
    VoiceTranslatorState state,
  ) {
    final cubit = context.read<VoiceTranslatorCubit>();
    final isListening = state is VoiceTranslatorListening;

    // Some common languages
    final languages = [
      {'id': 'en_US', 'name': 'English', 'flag': '🇺🇸'},
      {'id': 'fr_FR', 'name': 'French', 'flag': '🇫🇷'},
      {'id': 'es_ES', 'name': 'Spanish', 'flag': '🇪🇸'},
      {'id': 'de_DE', 'name': 'German', 'flag': '🇩🇪'},
      {'id': 'ru_RU', 'name': 'Russian', 'flag': '🇷🇺'},
      {'id': 'zh_CN', 'name': 'Chinese', 'flag': '🇨🇳'},
      {'id': 'hi_IN', 'name': 'Hindi', 'flag': '🇮🇳'},
      {'id': 'pt_BR', 'name': 'Portuguese', 'flag': '🇧🇷'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                color: const Color(0xFF3B82F6),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Source Language',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: cubit.selectedLocaleId,
              dropdownColor: const Color(0xFF1E1E2C),
              icon: Icon(Icons.arrow_drop_down_rounded, color: Colors.white70),
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              onChanged: isListening
                  ? null
                  : (String? newLocaleId) {
                      if (newLocaleId != null) {
                        final langName = languages.firstWhere(
                          (l) => l['id'] == newLocaleId,
                        )['name']!;
                        cubit.changeLanguage(newLocaleId, langName);
                      }
                    },
              items: languages.map((lang) {
                return DropdownMenuItem<String>(
                  value: lang['id'],
                  child: Row(
                    children: [
                      Text(lang['flag']!, style: TextStyle(fontSize: 16.sp)),
                      SizedBox(width: 8.w),
                      Text(lang['name']!),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseCard(BuildContext context, VoiceTranslatorState state) {
    Widget content;

    if (state is VoiceTranslatorNoMatch) {
      content = Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Column(
          children: [
            Icon(
              Icons.hearing_disabled_outlined,
              color: Colors.amber,
              size: 32.sp,
            ).animate().shake(duration: 400.ms),
            SizedBox(height: 12.h),
            Text(
              'no_match'.tr(context: context),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.amber,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'no_match_hint'.tr(context: context),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(color: Colors.white60),
            ),
          ],
        ),
      );
    } else if (state is VoiceTranslatorTranslating) {
      content = Column(
        children: [
          SizedBox(height: 20.h),
          const Center(
            child: CircularProgressIndicator(color: Color(0xFF10B981)),
          ),
          SizedBox(height: 16.h),
          Center(
            child: Text(
              'translating_now'.tr(context: context),
              style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
            ),
          ),
        ],
      );
    } else if (state is VoiceTranslatorSuccess) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Arabic Reply (Animated Typing)
          DefaultTextStyle(
            style: AppTextStyles.arabicBody.copyWith(
              fontSize: 26.sp,
              color: Colors.white,
              height: 1.6,
            ),
            textAlign: TextAlign.right,
            child: AnimatedTextKit(
              key: ValueKey(
                state.aiArabicReply,
              ), // Re-animates when text changes
              animatedTexts: [
                TyperAnimatedText(
                  state.aiArabicReply,
                  speed: const Duration(milliseconds: 40),
                  textStyle: AppTextStyles.arabicBody.copyWith(
                    fontSize: 26.sp,
                    color: Colors.white,
                    height: 1.6,
                  ),
                ),
              ],
              isRepeatingAnimation: false,
              displayFullTextOnTap: true,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1, end: 0),

          if (state.aiTranslation.isNotEmpty) ...[
            SizedBox(height: 16.h),
            Divider(color: Colors.white.withValues(alpha: 0.1)),
            SizedBox(height: 12.h),
            // Translation of reply
            Text(
              state.aiTranslation,
              textAlign: TextAlign.left,
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 16.sp,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          ],

          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                color: state.isSpeaking
                    ? const Color(0xFF10B981).withValues(alpha: 0.2)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  context.read<VoiceTranslatorCubit>().replayTranslation();
                },
                icon: Icon(
                  state.isSpeaking ? Icons.volume_up : Icons.volume_up_outlined,
                  color: state.isSpeaking
                      ? const Color(0xFF10B981)
                      : Colors.white54,
                  size: 28.sp,
                ),
              ),
            ),
          ),
        ],
      );
    } else if (state is VoiceTranslatorError) {
      content = Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Text(
          state.error,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.redAccent,
            fontSize: 14.sp,
          ),
        ),
      );
    } else {
      content = Padding(
        padding: EdgeInsets.only(top: 16.h),
        child: Text(
          'translation_placeholder'.tr(context: context),
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white30,
            fontSize: 16.sp,
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.auto_awesome,
                color: const Color(0xFF10B981),
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'translation'.tr(context: context).toUpperCase(),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF10B981),
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          content,
        ],
      ),
    );
  }

  Widget _buildMicControls(BuildContext context) {
    return BlocBuilder<VoiceTranslatorCubit, VoiceTranslatorState>(
      builder: (context, state) {
        final isListening = state is VoiceTranslatorListening;

        return GestureDetector(
          onTap: () async {
            if (isListening) {
              context.read<VoiceTranslatorCubit>().stopListening();
            } else {
              if (!await NetworkChecker.hasConnection()) {
                if (context.mounted) {
                  NetworkChecker.showNoNetworkDialog(context);
                }
                return;
              }
              if (!context.mounted) return;
              context.read<VoiceTranslatorCubit>().startListening();
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: isListening ? 90.w : 80.w,
            height: isListening ? 90.w : 80.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isListening ? Colors.redAccent : const Color(0xFFD4AF37),
              boxShadow: [
                BoxShadow(
                  color:
                      (isListening ? Colors.redAccent : const Color(0xFFD4AF37))
                          .withValues(alpha: 0.4),
                  blurRadius: isListening ? 25 : 15,
                  spreadRadius: isListening ? 5 : 0,
                ),
                if (!isListening)
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 10,
                    spreadRadius: -2,
                    offset: const Offset(0, -2),
                  ),
              ],
            ),
            child: Center(
              child: Icon(
                isListening ? Icons.stop_rounded : Icons.mic_rounded,
                color: Colors.white,
                size: isListening ? 45.sp : 35.sp,
              ),
            ),
          ),
        );
      },
    );
  }
}
