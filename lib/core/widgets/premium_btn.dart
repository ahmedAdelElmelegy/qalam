import 'package:arabic/core/theme/colors.dart';
import 'package:arabic/core/theme/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PremiumButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isGold;
  final bool isDanger;
  final IconData? icon;
  final double? width;
  final bool isLoading;

  const PremiumButton({
    super.key,
    required this.text,
    this.isLoading = false,
    required this.onPressed,
    this.isGold = true,
    this.isDanger = false,
    this.icon,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    // Define gradient based on status
    final Gradient gradient = isDanger
        ? const LinearGradient(
            colors: [Color(0xFFE94560), Color(0xFFC0392B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : (isGold ? AppColors.goldGradient : AppColors.mainGradient);

    final Color contentColor = isGold ? Colors.black : Colors.white;

    return Container(
      width: width ?? double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: isDanger
                ? const Color(0xFFE94560).withValues(alpha: 0.3)
                : (isGold
                    ? AppColors.accentGold.withValues(alpha: 0.4)
                    : AppColors.primaryDeep.withValues(alpha: 0.4)),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(16),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: contentColor,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (icon != null) ...[
                      Icon(icon, color: contentColor, size: 20.w),
                      SizedBox(width: 8.w),
                    ],
                    Text(
                      text,
                      style: AppTextStyles.buttonText.copyWith(
                        color: contentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
