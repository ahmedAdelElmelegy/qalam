import 'package:flutter/material.dart';

class AppColors {
  // ===========================================================================
  // NEW PREMIUM PALETTE (Dark/Gold)
  // ===========================================================================
  static const Color primaryDark = Color(0xFF1A1A2E);
  static const Color primaryNavy = Color(0xFF16213E);
  static const Color primaryDeep = Color(0xFF0F3460);

  // Accents (Gold/Amber)
  static const Color accentGold = Color(0xFFFFD700);
  static const Color accentAmber = Color(0xFFE94560);
  static const Color accentCyan = Color(0xFF00ADB5);

  // Glassmorphism
  static Color glassWhite = Colors.white.withValues(alpha: 0.1);
  static Color glassBlack = Colors.black.withValues(alpha: 0.2);
  static Color glassBorder = Colors.white.withValues(alpha: 0.2);

  // Text
  static const Color textPrimaryWithOpacity =
      Colors.white70; // For legacy mapping
  static const Color textGold = Color(0xFFFFD700);

  // Gradients
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryDark, primaryNavy],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA000)],
  );

  // ===========================================================================
  // LEGACY COMPATIBILITY (Mapping old keys to New Palette)
  // ===========================================================================

  // Map 'primary' to our Deep Blue or Gold?
  // Legacy app used Teal as primary. Let's make primary = PrimaryDeep for structure, or Gold for action?
  // Usually 'primary' in Flutter is the brand color.
  static const Color primary = primaryDeep;
  static const Color primaryLight = primaryNavy;
  static const Color primaryDarkLegacy =
      primaryDark; // Renamed to avoid collision if needed, or just use primaryDark

  // Secondary was Sand. Let's make it Gold.
  static const Color secondary = accentGold;
  static const Color secondaryLight = Color(0xFFFFE082);
  static const Color secondaryDark = Color(0xFFFFA000);

  // Accent
  static const Color accent = accentCyan;
  static const Color accentLight = Color(0xFF4DD0E1);
  static const Color accentDark = Color(0xFF006064);

  // Backgrounds - Force Dark Mode
  static const Color background = primaryDark;
  static const Color surface = primaryNavy;
  static const Color surfaceVariant = Color(0xFF1F2940);

  // Text Colors
  static const Color textPrimary = Colors.white; // Reversed for Dark Mode
  static const Color textSecondary = Colors.white70;
  static const Color textTertiary = Colors.white38;
  static const Color textOnPrimary = Colors.white;

  // Semantic
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE57373);
  static const Color warning = Color(0xFFFFB74D);
  static const Color info = Color(0xFF64B5F6);

  // Borders
  static Color border = Colors.white.withValues(alpha: 0.1);
  static Color divider = Colors.white.withValues(alpha: 0.1);

  // Shadows
  static Color shadowLight = Colors.black.withValues(alpha: 0.2);
  static Color shadowMedium = Colors.black.withValues(alpha: 0.4);
}
