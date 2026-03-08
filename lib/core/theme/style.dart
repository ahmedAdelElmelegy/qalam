import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppTextStyles {
  // ===========================================================================
  // NEW PREMIUM STYLES
  // ===========================================================================

  // English Titles (Serif for Premium feel)
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 32.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 24.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Arabic Titles (Calligraphic)
  static TextStyle get arabicTitle => GoogleFonts.amiri(
    fontSize: 30.sp,
    fontWeight: FontWeight.bold,
    color: AppColors.textGold,
  );

  static TextStyle get arabicBody => GoogleFonts.amiri(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  // Body Text (Sans-serif for readability)
  // NOT static getters to avoid const issues with ScreenUtil if init order varies,
  // but using static getters is safer for ScreenUtil.

  static TextStyle get bodyLarge => GoogleFonts.urbanist(
    fontSize: 16.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.urbanist(
    fontSize: 14.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static TextStyle get bodySmall => GoogleFonts.urbanist(
    fontSize: 12.sp,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  // Button Text
  static TextStyle get buttonText => GoogleFonts.urbanist(
    fontSize: 16.sp,
    fontWeight: FontWeight.w600,
    color: Colors.black, // On Gold
  );

  // ===========================================================================
  // LEGACY ALIASES (Mapping old H1/H2 to New Styles)
  // ===========================================================================

  static TextStyle get h1 => displayLarge;
  static TextStyle get h2 => displayMedium;
  static TextStyle get h3 => GoogleFonts.urbanist(
    fontSize: 20.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );
  static TextStyle get h4 => GoogleFonts.urbanist(
    fontSize: 18.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static TextStyle get buttonLarge => buttonText.copyWith(fontSize: 18.sp);
  static TextStyle get buttonMedium => buttonText;

  static TextStyle get label =>
      bodyMedium.copyWith(fontWeight: FontWeight.bold);
  static TextStyle get caption => bodySmall;

  // Overline
  static TextStyle get overline => GoogleFonts.urbanist(
    fontSize: 10.sp,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 1.2,
  );
}
