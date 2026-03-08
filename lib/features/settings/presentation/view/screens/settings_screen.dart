import 'package:arabic/core/helpers/extentions.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/utils/local_storage.dart';
import 'package:arabic/core/widgets/glass_container.dart';
import 'package:arabic/core/widgets/language_selector_sheet.dart';
import 'package:arabic/core/widgets/premium_btn.dart';
import 'package:arabic/features/auth/presentation/sign_in/view/screens/sign_in.dart';
import 'package:arabic/features/home/presentation/manager/home_progress_cubit.dart';
import 'package:arabic/features/settings/presentation/manager/get%20profile/get_profile_cubit.dart';
import 'package:arabic/features/settings/presentation/view/screens/terms_and_conditions_screen.dart';
import 'package:arabic/features/settings/presentation/view/widgets/profile_setting.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryDark,
      body: Stack(
        children: [
          // Dynamic Background Orbs
          _buildBackgroundOrb(
            top: -100,
            right: -50,
            color: AppColors.accentGold,
            size: 300,
            delay: 0,
            left: null,
          ),
          _buildBackgroundOrb(
            bottom: -50,
            left: -50,
            color: AppColors.primaryDeep,
            size: 250,
            delay: 400,
            top: null,
          ),
          _buildBackgroundOrb(
            top: 200,
            left: -80,
            color: AppColors.accentGold.withValues(alpha: 0.5),
            size: 150,
            delay: 800,
            right: null,
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
                        ProfileSetting(),
                        SizedBox(height: 32.h),

                        // Section: App Preferences
                        _buildSectionHeader('app_preferences'.tr()),
                        SizedBox(height: 16.h),

                        _buildSettingItem(
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

                        _buildTtsSpeedItem(),

                        SizedBox(height: 32.h),

                        // Section: Information
                        _buildSectionHeader('about'.tr()),
                        SizedBox(height: 16.h),

                        _buildSettingItem(
                          icon: Icons.info_outline_rounded,
                          title: 'app_version'.tr(),
                          subtitle: '1.0.0 (Build 5)',
                        ),
                        SizedBox(height: 12.h),

                        _buildSettingItem(
                          icon: Icons.description_outlined,
                          title: 'terms_and_conditions'.tr(),
                          onTap: () =>
                              context.push(const TermsAndConditionsScreen()),
                        ),
                        SizedBox(height: 12.h),

                        _buildSettingItem(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy', // Fallback until localized
                          onTap: () async {
                            final Uri url = Uri.parse(
                              'https://ahmedadel.github.io/qalam-arabic/privacy-policy.html',
                            );
                            if (!await launchUrl(url)) {
                              debugPrint('Could not launch \$url');
                            }
                          },
                        ),

                        SizedBox(height: 48.h),

                        // Premium Logout Button
                        Center(
                          child:
                              PremiumButton(
                                    text: 'logout'.tr(),
                                    isGold: false,
                                    isDanger: true,
                                    icon: Icons.logout_rounded,
                                    width: 0.8.sw,
                                    onPressed: () => _showLogoutDialog(),
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

  Widget _buildBackgroundOrb({
    required double? top,
    required double? left,
    double? right,
    double? bottom,
    required Color color,
    required double size,
    required int delay,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child:
          Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.1),
                ),
              )
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .fadeIn(delay: delay.ms, duration: 1.seconds)
              .scale()
              .moveY(begin: 0, end: 20, duration: 3.seconds),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title.toUpperCase(),
          style: AppTextStyles.overline.copyWith(
            color: AppColors.accentGold,
            fontSize: 13.sp,
            letterSpacing: 3,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4.h),
        Container(
          width: 40.w,
          height: 2,
          color: AppColors.accentGold.withValues(alpha: 0.3),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildTtsSpeedItem() {
    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.speed_rounded,
                  color: AppColors.accentGold,
                  size: 22.w,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'tts_speed'.tr(),
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                _getSpeedLabel(ttsSpeed),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.accentGold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.accentGold,
              inactiveTrackColor: Colors.white12,
              thumbColor: AppColors.accentGold,
              overlayColor: AppColors.accentGold.withValues(alpha: 0.1),
              trackHeight: 4.h,
            ),
            child: Slider(
              value: ttsSpeed,
              min: 0.1,
              max: 0.9,
              divisions: 8,
              onChanged: (value) {
                setState(() => ttsSpeed = value);
                TtsService().updateSpeed(value);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1, end: 0);
  }

  String _getSpeedLabel(double speed) {
    if (speed < 0.3) return 'slow'.tr();
    if (speed > 0.6) return 'fast'.tr();
    return 'normal'.tr();
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return GlassContainer(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      borderRadius: BorderRadius.circular(16),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.accentGold, size: 22.w),
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(color: Colors.white38),
              )
            : null,
        trailing: onTap != null
            ? const Icon(Icons.chevron_right, color: Colors.white30)
            : null,
        onTap: onTap,
      ),
    ).animate().fadeIn(delay: 400.ms).slideX(begin: 0.1, end: 0);
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

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: GlassContainer(
              width: 0.85.sw,
              padding: EdgeInsets.all(24.w),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE94560).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.logout_rounded,
                      color: const Color(0xFFE94560),
                      size: 32.w,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'logout_title'.tr(),
                    style: AppTextStyles.h3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'logout_confirmation'.tr(),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  PremiumButton(
                    text: 'logout'.tr(),
                    isGold: false,
                    isDanger: true,
                    onPressed: () async {
                      context.read<HomeProgressCubit>().clearProgress();
                      context.read<GetProfileCubit>().clearProfile();
                      await LocalStorage.clearAll();
                      if (mounted) {
                        context.pushAndRemoveUntil(const SignInScreen());
                      }
                    },
                  ),
                  SizedBox(height: 12.h),
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(
                      'cancel'.tr(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white38,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
