import 'package:flutter/material.dart';
import 'package:flutter_grocery/theme/app_colors.dart';
import 'package:flutter_grocery/theme/app_text_styles.dart';

/// Web-specific dark theme with Blue brand color
/// This theme is ONLY used for web platform
ThemeData webDark = ThemeData(
  fontFamily: AppTextStyles.fontFamily,
  primaryColor: AppColors.webPrimaryBlueDark,
  secondaryHeaderColor: AppColors.webDarkSurface,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.webDarkBackground,
  cardColor: AppColors.webDarkCard,
  focusColor: AppColors.webDarkBorderFocus,
  hintColor: AppColors.webDarkTextHint,
  canvasColor: AppColors.webDarkBackground,
  shadowColor: Colors.black.withValues(alpha: 0.4),
  dividerColor: AppColors.webDarkDivider,

  // Modern elevation-based shadow system
  useMaterial3: true,

  // AppBar theme for web dark
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.webDarkSurface,
    foregroundColor: AppColors.webDarkTextPrimary,
    elevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.webDarkTextPrimary,
    ),
    iconTheme: IconThemeData(
      color: AppColors.webDarkTextPrimary,
    ),
  ),

  // Text theme for web dark
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
      color: AppColors.webDarkTextPrimary,
    ),
    titleMedium: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.webDarkTextPrimary,
    ),
    titleSmall: TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.webDarkTextSecondary,
    ),
  ),

  // Elevated button theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.webDarkButtonPrimary,
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
      foregroundColor: AppColors.webDarkButtonPrimary,
      side: const BorderSide(color: AppColors.webDarkButtonPrimary, width: 1.5),
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
      foregroundColor: AppColors.webDarkButtonPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: AppTextStyles.webButtonMedium,
    ),
  ),

  // Input decoration theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.webDarkSurface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webDarkBorder, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webDarkBorder, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: const BorderSide(color: AppColors.webDarkButtonPrimary, width: 2),
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
      color: AppColors.webDarkTextHint,
    ),
    labelStyle: const TextStyle(
      fontFamily: AppTextStyles.fontFamily,
      fontSize: 14,
      color: AppColors.webDarkTextSecondary,
    ),
  ),

  // Card theme
  cardTheme: CardThemeData(
    color: AppColors.webDarkCard,
    elevation: 2,
    shadowColor: Colors.black.withValues(alpha: 0.4),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Dialog theme
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.webDarkSurface,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),

  // Bottom sheet theme
  bottomSheetTheme: const BottomSheetThemeData(
    backgroundColor: AppColors.webDarkSurface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),

  // Popup menu theme
  popupMenuTheme: PopupMenuThemeData(
    color: AppColors.webDarkCard,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),

  // Chip theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.webDarkButtonSecondary,
    disabledColor: AppColors.webDarkButtonDisabled,
    selectedColor: AppColors.webDarkButtonPrimary,
    secondarySelectedColor: AppColors.webPrimaryBlueLight,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    labelStyle: AppTextStyles.webLabelSmall,
    secondaryLabelStyle: const TextStyle(color: Colors.white),
    brightness: Brightness.dark,
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
    brightness: Brightness.dark,
    primary: AppColors.webPrimaryBlueDark,
    onPrimary: Colors.white,
    primaryContainer: AppColors.webPrimaryBlueDark,
    onPrimaryContainer: AppColors.webPrimaryBlueLight,
    secondary: AppColors.webSecondaryGreyLight,
    onSecondary: Colors.white,
    secondaryContainer: AppColors.webSecondaryGrey,
    onSecondaryContainer: Colors.white,
    tertiary: AppColors.webAccentOrange,
    onTertiary: Colors.white,
    error: AppColors.webErrorLight,
    onError: Colors.white,
    errorContainer: AppColors.webError,
    onErrorContainer: AppColors.webErrorLight,
    surface: AppColors.webDarkSurface,
    onSurface: AppColors.webDarkTextPrimary,
    onSurfaceVariant: AppColors.webDarkTextSecondary,
    outline: AppColors.webDarkBorder,
    outlineVariant: AppColors.webDarkDivider,
    shadow: Colors.black,
    scrim: Colors.black87,
    inverseSurface: AppColors.webLightSurface,
    onInverseSurface: AppColors.webLightTextPrimary,
    inversePrimary: AppColors.webPrimaryBlue,
    surfaceTint: AppColors.webPrimaryBlueDark,
  ),
);
