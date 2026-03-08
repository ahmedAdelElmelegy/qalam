import 'package:arabic/core/helpers/show_snake_bar.dart';
import 'package:arabic/features/auth/presentation/manager/language/language_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/curriculum_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/lessons/lesson_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/level/level_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/quiz/quiz_cubit.dart';
import 'package:arabic/features/curriculum/presentation/manager/units/unit_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/update%20profile/update_profile_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';

class LanguageSelectorSheet extends StatefulWidget {
  const LanguageSelectorSheet({super.key});

  @override
  State<LanguageSelectorSheet> createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends State<LanguageSelectorSheet> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageCubit>().getLanguages();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateProfileCubit, UpdateProfileState>(
      listener: (context, state) {
        if (state is UpdateProfileSuccess) {
          AppSnakeBar.showSuccessMessage(
            context,
            'language_update_sucessful'.tr(),
          );

          // Optional: refresh profile data
          final userId = context.read<GetProfileCubit>().profile?.id;
          if (userId != null) {
            context.read<GetProfileCubit>().getProfile(userId);
          }
        } else if (state is UpdateProfileFailure) {
          AppSnakeBar.showErrorMessage(context, state.message);
        }
      },
      child: GlassContainer(
        width: double.infinity,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        padding: EdgeInsets.zero,
        border: Border(
          top: BorderSide(
            color: AppColors.accentGold.withValues(alpha: 0.3),
            width: 2,
          ),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 50.w,
                height: 5.h,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              SizedBox(height: 24.h),

              // Header
              Row(
                children: [
                  Icon(
                    Icons.language_rounded,
                    color: AppColors.accentGold,
                    size: 28.w,
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'language'.tr(),
                    style: AppTextStyles.h2.copyWith(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.1, end: 0),

              SizedBox(height: 32.h),

              // Language List
              Expanded(
                child: ListView.separated(
                  // shrinkWrap: true,
                  // physics: const NeverScrollableScrollPhysics(),
                  itemCount: context.supportedLocales.length,
                  separatorBuilder: (context, index) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final locale = context.supportedLocales[index];
                    final isSelected = context.locale == locale;

                    return _buildLanguageItem(locale, isSelected, index);
                  },
                ),
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageItem(Locale locale, bool isSelected, int index) {
    return InkWell(
      onTap: () async {
        if (!isSelected) {
          // 1. Change locale locally
          await context.setLocale(locale);
          await LocalStorage.saveLanguage(locale.languageCode);

          // Clear curriculum caches to force reload with new language
          if (mounted) {
            context.read<LevelCubit>().clearCache();
            context.read<UnitCubit>().clearCache();
            context.read<LessonCubit>().clearCache();
            context.read<QuizCubit>().clearCache();
            // ignore: invalid_use_of_protected_member
            context.read<CurriculumCubit>().reset();
          }

          // 2. Sync with API
          if (mounted) {
            final profile = context.read<GetProfileCubit>().profile;
            if (profile != null) {
              final languages = context.read<LanguageCubit>().languages;
              try {
                final lang = languages.firstWhere(
                  (element) => element.code == locale.languageCode,
                );

                if (mounted) {
                  context.read<UpdateProfileCubit>().updateLanguage(
                    languageId: lang.id,
                    profile: profile,
                  );
                }
              } catch (e) {
                debugPrint(
                  'Language code not found in API list: ${locale.languageCode}',
                );
              }
            }
          }

          if (mounted) setState(() {});
          Future.delayed(300.ms, () {
            if (mounted) Navigator.pop(context);
          });
        } else {
          Navigator.pop(context);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: 300.ms,
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: isSelected ? AppColors.goldGradient : null,
          color: isSelected ? null : Colors.white.withValues(alpha: 0.05),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.accentGold.withValues(alpha: 0.3),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.1),
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.black.withValues(alpha: 0.1)
                    : AppColors.accentGold.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                locale.languageCode.toUpperCase(),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? Colors.black : AppColors.accentGold,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Text(
              _getLanguageName(locale.languageCode),
              style: AppTextStyles.bodyLarge.copyWith(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 16.sp,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: Colors.black,
                size: 24.w,
              ).animate().scale(duration: 200.ms),
          ],
        ),
      ).animate().fadeIn(delay: (index * 50).ms).slideX(begin: 0.1, end: 0),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'العربية';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      case 'zh':
        return '中文';
      case 'ru':
        return 'Русский';
      default:
        return code;
    }
  }
}

void showLanguageSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => const LanguageSelectorSheet(),
  );
}
