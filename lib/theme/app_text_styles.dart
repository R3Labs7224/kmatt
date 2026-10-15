import 'package:flutter/material.dart';

/// Centralized typography system for the entire application
/// Font Family: Poppins (for both web and mobile)
class AppTextStyles {
  AppTextStyles._();

  // Font family constant
  static const String fontFamily = 'Poppins';

  // ============================================================================
  // WEB TEXT STYLES (Red Theme - Modern & Clean)
  // ============================================================================

  // Heading styles for web
  static const TextStyle webH1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 48,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle webH2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.5,
  );

  static const TextStyle webH3 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 26, // Reduced by 20% from 32
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.25,
  );

  static const TextStyle webH4 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
  );

  static const TextStyle webH5 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  static const TextStyle webH6 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0,
  );

  // Body text styles for web
  static const TextStyle webBodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  static const TextStyle webBodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  static const TextStyle webBodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  // Label/Button styles for web
  static const TextStyle webLabelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 0.5,
  );

  static const TextStyle webLabelMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.25,
  );

  static const TextStyle webLabelSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0.25,
  );

  // Button text styles for web
  static const TextStyle webButtonLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.75,
  );

  static const TextStyle webButtonMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  static const TextStyle webButtonSmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.5,
  );

  // Caption/Helper text for web
  static const TextStyle webCaption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0.25,
  );

  static const TextStyle webOverline = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 1.5,
  );

  // ============================================================================
  // MOBILE TEXT STYLES (Existing Poppins - DO NOT MODIFY)
  // ============================================================================

  // Mobile base styles - kept from existing styles.dart
  static const TextStyle mobileLight = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w300,
  );

  static const TextStyle mobileRegular = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle mobileMedium = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle mobileSemiBold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle mobileBold = TextStyle(
    fontFamily: fontFamily,
    fontWeight: FontWeight.w700,
  );

  // ============================================================================
  // HELPER METHODS FOR RESPONSIVE TEXT
  // ============================================================================

  /// Get heading style based on platform
  static TextStyle getH1({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webH1.copyWith(color: color);
    } else {
      return mobileBold.copyWith(fontSize: 32, color: color);
    }
  }

  static TextStyle getH2({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webH2.copyWith(color: color);
    } else {
      return mobileBold.copyWith(fontSize: 28, color: color);
    }
  }

  static TextStyle getH3({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webH3.copyWith(color: color);
    } else {
      return mobileSemiBold.copyWith(fontSize: 24, color: color);
    }
  }

  static TextStyle getH4({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webH4.copyWith(color: color);
    } else {
      return mobileSemiBold.copyWith(fontSize: 20, color: color);
    }
  }

  static TextStyle getBodyLarge({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webBodyLarge.copyWith(color: color);
    } else {
      return mobileRegular.copyWith(fontSize: 16, color: color);
    }
  }

  static TextStyle getBodyMedium({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webBodyMedium.copyWith(color: color);
    } else {
      return mobileRegular.copyWith(fontSize: 14, color: color);
    }
  }

  static TextStyle getButtonText({required bool isWeb, Color? color}) {
    if (isWeb) {
      return webButtonMedium.copyWith(color: color);
    } else {
      return mobileSemiBold.copyWith(fontSize: 14, color: color);
    }
  }
}
