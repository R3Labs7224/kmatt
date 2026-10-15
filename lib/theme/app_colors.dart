import 'package:flutter/material.dart';

/// Centralized color system for the entire application
/// This provides a single source of truth for all colors used across web and mobile platforms
class AppColors {
  AppColors._();

  // ============================================================================
  // WEB BRAND COLORS (Purple Theme)
  // ============================================================================

  /// Primary brand color for web
  static const Color webPrimaryBlue = Color(0xFF6C2C81);
  static const Color webPrimaryBlueDark = Color(0xFF521F61);
  static const Color webPrimaryBlueLight = Color(0xFF8A3FA0);

  /// Secondary colors for web
  static const Color webSecondaryGrey = Color(0xFF2C3E50);
  static const Color webSecondaryGreyLight = Color(0xFF34495E);

  /// Accent colors for web
  static const Color webAccentOrange = Color(0xFFFF6B35);
  static const Color webAccentBlue = Color(0xFF3498DB);
  static const Color webAccentGreen = Color(0xFF27AE60);

  // ============================================================================
  // WEB LIGHT THEME COLORS
  // ============================================================================

  static const Color webLightBackground = Color(0xFFFAFAFA);
  static const Color webLightSurface = Color(0xFFFFFFFF);
  static const Color webLightCard = Color(0xFFFFFFFF);
  static const Color webLightDivider = Color(0xFFE0E0E0);

  /// Text colors for web light theme
  static const Color webLightTextPrimary = Color(0xFF212121);
  static const Color webLightTextSecondary = Color(0xFF757575);
  static const Color webLightTextHint = Color(0xFF9E9E9E);

  /// Border colors for web light theme
  static const Color webLightBorder = Color(0xFFE0E0E0);
  static const Color webLightBorderFocus = Color(0xFF6C2C81);

  /// Button colors for web light theme
  static const Color webLightButtonPrimary = Color(0xFF6C2C81);
  static const Color webLightButtonSecondary = Color(0xFFF5F5F5);
  static const Color webLightButtonDisabled = Color(0xFFBDBDBD);

  // ============================================================================
  // WEB DARK THEME COLORS
  // ============================================================================

  static const Color webDarkBackground = Color(0xFF121212);
  static const Color webDarkSurface = Color(0xFF1E1E1E);
  static const Color webDarkCard = Color(0xFF2C2C2C);
  static const Color webDarkDivider = Color(0xFF373737);

  /// Text colors for web dark theme
  static const Color webDarkTextPrimary = Color(0xFFE0E0E0);
  static const Color webDarkTextSecondary = Color(0xFFB0B0B0);
  static const Color webDarkTextHint = Color(0xFF757575);

  /// Border colors for web dark theme
  static const Color webDarkBorder = Color(0xFF373737);
  static const Color webDarkBorderFocus = Color(0xFF8A3FA0);

  /// Button colors for web dark theme
  static const Color webDarkButtonPrimary = Color(0xFF8A3FA0);
  static const Color webDarkButtonSecondary = Color(0xFF2C2C2C);
  static const Color webDarkButtonDisabled = Color(0xFF424242);

  // ============================================================================
  // WEB SEMANTIC COLORS (Work for both light and dark)
  // ============================================================================

  static const Color webSuccess = Color(0xFF27AE60);
  static const Color webSuccessLight = Color(0xFF2ECC71);
  static const Color webError = Color(0xFFE74C3C);
  static const Color webErrorLight = Color(0xFFE57373);
  static const Color webWarning = Color(0xFFF39C12);
  static const Color webWarningLight = Color(0xFFFFB74D);
  static const Color webInfo = Color(0xFF3498DB);
  static const Color webInfoLight = Color(0xFF64B5F6);

  // ============================================================================
  // MOBILE COLORS (Existing - DO NOT MODIFY)
  // ============================================================================

  /// Mobile light theme - Primary colors (Purple theme)
  static const Color mobilePrimaryBlue = Color(0xFF6C2C81);
  static const Color mobileSecondaryLight = Color(0xFFEFE6FE);
  static const Color mobileBlueDark = Color(0xFF521F61);

  /// Mobile dark theme - Primary colors (Light Purple theme)
  static const Color mobilePrimaryLightBlue = Color(0xFF9B59B6);
  static const Color mobileSecondaryDark = Color(0xFF8E7A9E);

  // ============================================================================
  // SHARED SEMANTIC COLORS (Used by mobile - DO NOT MODIFY)
  // ============================================================================

  static const Color cartShadowColor = Color(0xFFA7A7A7);
  static const Color ratingColor = Color(0xFFFFBA08);
  static const Color colorGreen = Color(0xFF057237);
  static const Color colorBlue = Color(0xFF1692C9);
  static const Color redColor = Color(0xFFFF5C00);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get primary color based on platform and theme
  static Color getPrimaryColor({required bool isWeb, required bool isDark}) {
    if (isWeb) {
      return isDark ? webPrimaryBlueDark : webPrimaryBlue;
    } else {
      return isDark ? mobilePrimaryLightBlue : mobilePrimaryBlue;
    }
  }

  /// Get background color based on platform and theme
  static Color getBackgroundColor({required bool isWeb, required bool isDark}) {
    if (isWeb) {
      return isDark ? webDarkBackground : webLightBackground;
    } else {
      return isDark ? const Color(0xFF2C2C2C) : const Color(0xFFFAFAFA);
    }
  }

  /// Get surface color based on platform and theme
  static Color getSurfaceColor({required bool isWeb, required bool isDark}) {
    if (isWeb) {
      return isDark ? webDarkSurface : webLightSurface;
    } else {
      return isDark ? const Color(0xFF121212) : Colors.white;
    }
  }

  /// Get text primary color based on platform and theme
  static Color getTextPrimaryColor({required bool isWeb, required bool isDark}) {
    if (isWeb) {
      return isDark ? webDarkTextPrimary : webLightTextPrimary;
    } else {
      return isDark ? Colors.white70 : const Color(0xFF002349);
    }
  }

  /// Get text secondary color based on platform and theme
  static Color getTextSecondaryColor({required bool isWeb, required bool isDark}) {
    if (isWeb) {
      return isDark ? webDarkTextSecondary : webLightTextSecondary;
    } else {
      return isDark ? const Color(0xFFb2b8bd) : const Color(0xFF52575C);
    }
  }
}
