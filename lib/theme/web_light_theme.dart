import 'package:flutter/material.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';

/// Web-specific light theme with Blue brand color
/// This theme is ONLY used for web platform
ThemeData webLight = ThemeData(
  fontFamily: AppTextStyles.fontFamily,
  primaryColor: AppColors.webPrimaryBlue,
  secondaryHeaderColor: AppColors.webLightSurface,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.webLightBackground,
  cardColor: AppColors.webLightCard,
  focusColor: AppColors.webLightBorderFocus,
  hintColor: AppColors.webLightTextHint,
  canvasColor: AppColors.webLightBackground,
  shadowColor: Colors.black.withValues(alpha: 0.08),
  dividerColor: AppColors.webLightDivider,

  // Modern elevation-based shadow system
  useMaterial3: true,

  // AppBar theme for web
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.webLightSurface,
    foregroundColor: AppColors.webLightTextPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.webLightTextPrimary,
    ),
    iconTheme: IconThemeData(
      color: AppColors.webLightTextPrimary,
    ),
  ),

  // Text theme for web
  textTheme: const TextTheme(
    displayLarge: AppTextStyles.webH1,
    displayMedium: AppTextStyles.webH2,
    displaySmall: AppTextStyles.webH3,
    headlineLarge: AppTextStyles.webH4,
    headlineMedium: AppTextStyles.webH5,
    headlineSmall: AppTextStyles.webH6,
    bodyLarge: AppTextStyles.webBodyLarge,
    bodyMedium: AppTextStyles.webBodyMedium,
    bodySmall: AppTextStyles.webBodySmall,
    labelLarge: AppTextStyles.webLabelLarge,
    labelMedium: AppTextStyles.webLabelMedium,
    labelSmall: AppTextStyles.webLabelSmall,
    titleLarge: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.webLightTextPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.webLightTextPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.webLightTextSecondary,
    ),
  ),

  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.webPrimaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.webButtonMedium,
    ),
  ),

  // Outlined button theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.webPrimaryBlue,
      side: const BorderSide(color: AppColors.webPrimaryBlue, width: 1.5),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: AppTextStyles.webButtonMedium,
    ),
  ),

  // Text button theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.webPrimaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: AppTextStyles.webButtonMedium,
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.webLightSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webLightBorder, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webLightBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webPrimaryBlue, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webError, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webError, width: 2),
    ),
    hintStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
      color: AppColors.webLightTextHint,
    ),
    labelStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
      color: AppColors.webLightTextSecondary,
    ),
  ),

  // Card theme
  cardTheme: CardThemeData(
    color: AppColors.webLightCard,
    elevation: 1,
    shadowColor: Colors.black.withValues(alpha: 0.08),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Dialog theme
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.webLightSurface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Bottom sheet theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.webLightSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),

  // Popup menu theme
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.webLightSurface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.webLightButtonSecondary,
    disabledColor: AppColors.webLightButtonDisabled,
    selectedColor: AppColors.webPrimaryBlue,
    secondarySelectedColor: AppColors.webPrimaryBlueLight,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: AppTextStyles.webLabelSmall,
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.light,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  // Page transitions
  pageTransitionsTheme: const PageTransitionsTheme(
    builders: {
      TargetPlatform.android: ZoomPageTransitionsBuilder(),
      TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
      TargetPlatform.linux: ZoomPageTransitionsBuilder(),
      TargetPlatform.macOS: ZoomPageTransitionsBuilder(),
      TargetPlatform.windows: ZoomPageTransitionsBuilder(),
    },
  ),

  // Color scheme for Material 3
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.webPrimaryBlue,
    onPrimary: Colors.white,
    primaryContainer: AppColors.webPrimaryBlueLight,
    onPrimaryContainer: AppColors.webPrimaryBlueDark,
    secondary: AppColors.webSecondaryGrey,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.webSecondaryGreyLight,
    onSecondaryContainer: Colors.white,
    tertiary: AppColors.webAccentOrange,
    onTertiary: Colors.white,
    error: AppColors.webError,
    onError: Colors.white,
    errorContainer: AppColors.webErrorLight,
    onErrorContainer: AppColors.webError,
    surface: AppColors.webLightSurface,
    onSurface: AppColors.webLightTextPrimary,
    onSurfaceVariant: AppColors.webLightTextSecondary,
    outline: AppColors.webLightBorder,
    outlineVariant: AppColors.webLightDivider,
    shadow: Colors.black,
    scrim: Colors.black54,
    inverseSurface: AppColors.webDarkSurface,
    onInverseSurface: AppColors.webDarkTextPrimary,
    inversePrimary: AppColors.webPrimaryBlueLight,
    surfaceTint: AppColors.webPrimaryBlue,
  ),
);
