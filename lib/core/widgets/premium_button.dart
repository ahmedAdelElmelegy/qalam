import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGold;
  final double? width;

  const PremiumButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGold = true,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: 56.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isGold ? AppColors.goldGradient : AppColors.mainGradient,
        boxShadow: [
          BoxShadow(
            color: isGold
                ? AppColors.accentGold.withValues(alpha: 0.4)
                : AppColors.primaryDeep.withValues(alpha: 0.4),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.buttonText.copyWith(
                color: isGold ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
