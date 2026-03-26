import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/language_selector_sheet.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/settings/presentation/view/screens/terms_and_conditions_screen.dart';
import 'package:arabic/features/settings/presentation/view/widgets/profile_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/profile_background_orb.dart';
import '../widgets/settings_section_header.dart';
import '../widgets/settings_item.dart';
import '../widgets/tts_speed_setting_item.dart';
import '../widgets/logout_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String currentLang = 'en';
  double ttsSpeed = 0.42;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final lang = await LocalStorage.getLanguage();
    final speed = await LocalStorage.getTtsSpeed();
    if (mounted) {
      setState(() {
        currentLang = lang ?? 'en';
        ttsSpeed = speed;
      });
    }
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'ar':
        return 'اللغة العربية';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Dynamic Background Orbs
          const ProfileBackgroundOrb(
            top: -100,
            right: -50,
            color: AppColors.accentGold,
            size: 300,
            delay: 0,
          ),
          const ProfileBackgroundOrb(
            bottom: -50,
            left: -50,
            color: AppColors.primaryDeep,
            size: 250,
            delay: 400,
          ),
          ProfileBackgroundOrb(
            top: 200,
            left: -80,
            color: AppColors.accentGold.withValues(alpha: 0.5),
            size: 150,
            delay: 800,
          ),

          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Premium Header
                SliverAppBar(
                  expandedHeight: 0,
                  floating: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: GlassContainer(
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(12),
                      child: BackButton(
                        color: AppColors.accentGold,
                        onPressed: () => context.pop(),
                      ),
                    ),
                  ),
                  title: Text(
                    'settings'.tr(),
                    style: AppTextStyles.displayMedium.copyWith(
                      color: Colors.white,
                      fontSize: 24.sp,
                      letterSpacing: 1.2,
                    ),
                  ).animate().fadeIn().slideX(begin: 0.1, end: 0),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Section with Animation
                        const ProfileSetting(),
                        SizedBox(height: 32.h),

                        // Section: App Preferences
                        SettingsSectionHeader(title: 'app_preferences'.tr()),
                        SizedBox(height: 16.h),

                        SettingsItem(
                          icon: Icons.language_rounded,
                          title: 'language'.tr(),
                          subtitle: _getLanguageName(currentLang),
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              backgroundColor: Colors.transparent,
                              builder: (context) =>
                                  const LanguageSelectorSheet(),
                            );
                            _loadUserData();
                          },
                        ),
                        SizedBox(height: 12.h),

                        TtsSpeedSettingItem(
                          ttsSpeed: ttsSpeed,
                          onChanged: (value) => setState(() => ttsSpeed = value),
                        ),

                        SizedBox(height: 32.h),

                        // Section: Information
                        SettingsSectionHeader(title: 'about'.tr()),
                        SizedBox(height: 16.h),

                        SettingsItem(
                          icon: Icons.info_outline_rounded,
                          title: 'app_version'.tr(),
                          subtitle: '1.0.1 (Build 2)',
                        ),
                        SizedBox(height: 12.h),

                        SettingsItem(
                          icon: Icons.description_outlined,
                          title: 'terms_and_conditions'.tr(),
                          onTap: () =>
                              context.push(const TermsAndConditionsScreen()),
                        ),
                        SizedBox(height: 12.h),

                        SettingsItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy', // Fallback until localized
                          onTap: () async {
                            final Uri url = Uri.parse(
                              'https://ahmedadelelmelegy.github.io/qalam-arabic/',
                            );
                            if (!await launchUrl(url)) {
                              debugPrint('Could not launch \$url');
                            }
                          },
                        ),

                        SizedBox(height: 48.h),

                        // Premium Logout Button
                        Center(
                          child: PremiumButton(
                                text: 'logout'.tr(),
                                isGold: false,
                                isDanger: true,
                                icon: Icons.logout_rounded,
                                width: 0.8.sw,
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (ctx) => const LogoutDialog(),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: 600.ms)
                              .slideY(begin: 0.2, end: 0),
                        ),
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
