import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';

// Placeholder for the Map Widget until configured
class MuseumMapWidget extends StatelessWidget {
  const MuseumMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryNavy,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map_rounded,
              size: 80,
              color: AppColors.accentGold.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Interactive Museum Map',
              style: AppTextStyles.displayMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Explore historical sites virtually.',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
