import 'package:flutter/material.dart';
import 'package:flutter_grocery/helper/responsive_helper.dart';

/// Utility class for responsive dimensions on web
/// Provides scaled measurements based on screen width while maintaining exact design on desktop (>=1300px)
class ResponsiveDimensions {

  /// Get scaling factor based on current breakpoint
  /// Desktop (>=1300px) returns 1.0 (100% - exact current design)
  /// Smaller screens return proportional scaling
  static double getScaleFactor(BuildContext context) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);
    final screenWidth = MediaQuery.of(context).size.width;

    switch (breakpoint) {
      case ResponsiveBreakpoint.desktopLarge:
        return 1.0; // Keep exact design
      case ResponsiveBreakpoint.desktop:
        return 1.0; // Keep exact design
      case ResponsiveBreakpoint.laptop:
        return 0.85; // Scale to 85%
      case ResponsiveBreakpoint.tabletLandscape:
        return 0.75; // Scale to 75%
      case ResponsiveBreakpoint.tabletPortrait:
        return 0.65; // Scale to 65%
      case ResponsiveBreakpoint.mobileLarge:
      case ResponsiveBreakpoint.mobileSmall:
        // Dynamic scaling for mobile based on screen width
        // At 600px: 0.6, at 480px: 0.48, at 375px: 0.375, at 320px: 0.32
        return (screenWidth / 1000).clamp(0.3, 0.6);
      case ResponsiveBreakpoint.mobileApp:
        return 1.0; // Native app uses different layouts
    }
  }

  /// Scale a dimension value based on screen size
  static double scale(BuildContext context, double value) {
    return value * getScaleFactor(context);
  }

  /// Get responsive width with max constraint
  static double width(BuildContext context, double baseWidth, {double? maxWidth}) {
    final scaled = scale(context, baseWidth);
    if (maxWidth != null && scaled > maxWidth) {
      return maxWidth;
    }
    return scaled;
  }

  /// Get responsive height
  static double height(BuildContext context, double baseHeight) {
    return scale(context, baseHeight);
  }

  /// Get responsive font size
  static double fontSize(BuildContext context, double baseFontSize) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);

    // Don't scale fonts as aggressively as dimensions
    switch (breakpoint) {
      case ResponsiveBreakpoint.desktopLarge:
      case ResponsiveBreakpoint.desktop:
        return baseFontSize;
      case ResponsiveBreakpoint.laptop:
        return baseFontSize * 0.95;
      case ResponsiveBreakpoint.tabletLandscape:
        return baseFontSize * 0.9;
      case ResponsiveBreakpoint.tabletPortrait:
        return baseFontSize * 0.85;
      case ResponsiveBreakpoint.mobileLarge:
      case ResponsiveBreakpoint.mobileSmall:
        return baseFontSize * 0.9;
      case ResponsiveBreakpoint.mobileApp:
        return baseFontSize;
    }
  }

  /// Get responsive padding
  static double padding(BuildContext context, double basePadding) {
    return scale(context, basePadding);
  }

  /// Get number of columns for grid layouts
  static int getGridColumns(BuildContext context, {int desktopColumns = 6}) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);

    switch (breakpoint) {
      case ResponsiveBreakpoint.desktopLarge:
      case ResponsiveBreakpoint.desktop:
        return desktopColumns;
      case ResponsiveBreakpoint.laptop:
        return (desktopColumns * 0.83).round().clamp(1, desktopColumns); // ~5 for 6
      case ResponsiveBreakpoint.tabletLandscape:
        return (desktopColumns * 0.67).round().clamp(1, desktopColumns); // ~4 for 6
      case ResponsiveBreakpoint.tabletPortrait:
        return (desktopColumns * 0.5).round().clamp(1, desktopColumns); // ~3 for 6
      case ResponsiveBreakpoint.mobileLarge:
        return 2;
      case ResponsiveBreakpoint.mobileSmall:
        return 2;
      case ResponsiveBreakpoint.mobileApp:
        return 2;
    }
  }

  /// Get max content width based on breakpoint
  static double getMaxContentWidth(BuildContext context) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);

    switch (breakpoint) {
      case ResponsiveBreakpoint.desktopLarge:
        return 1920;
      case ResponsiveBreakpoint.desktop:
        return 1555; // Current max width
      case ResponsiveBreakpoint.laptop:
        return 1200;
      case ResponsiveBreakpoint.tabletLandscape:
        return 960;
      case ResponsiveBreakpoint.tabletPortrait:
        return 720;
      case ResponsiveBreakpoint.mobileLarge:
      case ResponsiveBreakpoint.mobileSmall:
        return double.infinity; // Full width on mobile
      case ResponsiveBreakpoint.mobileApp:
        return double.infinity;
    }
  }

  /// Check if current view should use mobile layout
  static bool shouldUseMobileLayout(BuildContext context) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);
    return breakpoint == ResponsiveBreakpoint.mobileSmall ||
           breakpoint == ResponsiveBreakpoint.mobileLarge ||
           breakpoint == ResponsiveBreakpoint.tabletPortrait;
  }

  /// Get responsive horizontal padding for main content
  static double getHorizontalPadding(BuildContext context) {
    final breakpoint = ResponsiveHelper.getBreakpoint(context);

    switch (breakpoint) {
      case ResponsiveBreakpoint.desktopLarge:
      case ResponsiveBreakpoint.desktop:
        return 24;
      case ResponsiveBreakpoint.laptop:
        return 20;
      case ResponsiveBreakpoint.tabletLandscape:
        return 16;
      case ResponsiveBreakpoint.tabletPortrait:
        return 12;
      case ResponsiveBreakpoint.mobileLarge:
      case ResponsiveBreakpoint.mobileSmall:
        return 12;
      case ResponsiveBreakpoint.mobileApp:
        return 16;
    }
  }
}
