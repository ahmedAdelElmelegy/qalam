import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:arabic/core/services/tts_service.dart';
import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:arabic/core/widgets/glass_container.dart';

class TtsSpeedSettingItem extends StatelessWidget {
  final double ttsSpeed;
  final ValueChanged<double> onChanged;

  const TtsSpeedSettingItem({
    super.key,
    required this.ttsSpeed,
    required this.onChanged,
  });

  String _getSpeedLabel(double speed) {
    if (speed < 0.3) return 'slow'.tr();
    if (speed > 0.6) return 'fast'.tr();
    return 'normal'.tr();
  }

  @override
  Widget build(BuildContext context) {
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
                onChanged(value);
                TtsService().updateSpeed(value);
              },
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 450.ms).slideX(begin: 0.1, end: 0);
  }
}
