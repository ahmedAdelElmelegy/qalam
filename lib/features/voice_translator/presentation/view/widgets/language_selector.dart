import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_cubit.dart';
import 'package:arabic/features/voice_translator/presentation/manager/voice_translator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSelector extends StatelessWidget {
  final VoiceTranslatorState state;

  const LanguageSelector({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
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
              icon: const Icon(Icons.arrow_drop_down_rounded, color: Colors.white70),
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
}
