import 'package:flutter/material.dart';
import 'package:flutter_grocery/utill/app_constants.dart';

ThemeData dark = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFF9B59B6),
  secondaryHeaderColor: const Color(0xFF8E7A9E),
  brightness: Brightness.dark,
  scaffoldBackgroundColor: const Color(0xFF2C2C2C),
  cardColor: const Color(0xFF121212),
  hintColor: const Color(0xFFE7F6F8),
  focusColor: const Color(0xFFADC4C8),
  canvasColor: const Color(0xFF4d5054),
  shadowColor: Colors.black.withValues(alpha: 0.4),
  textTheme: TextTheme(titleLarge: TextStyle(color: const Color(0xFFE0E0E0).withValues(alpha: 0.3))),
  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
  popupMenuTheme: const PopupMenuThemeData(color: Color(0xFF29292D), surfaceTintColor: Color(0xFF29292D)),
  dialogTheme: const DialogThemeData(surfaceTintColor: Colors.white10),
  colorScheme: ColorScheme(
    brightness: Brightness.dark,
    primary: const Color(0xFF9B59B6),
    onPrimary: const Color(0xFF9B59B6),
    secondary: const Color(0xFF8E7A9E),
    onSecondary: const Color(0xFFEFE6FE),
    error: Colors.redAccent,
    onError: Colors.redAccent,
    surface: Colors.white10,
    onSurface:  Colors.white70,
    shadow: Colors.black.withValues(alpha: 0.4),
  ),
);
