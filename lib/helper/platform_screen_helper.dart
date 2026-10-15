import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// Helper class to route between web and mobile screens
/// This ensures complete separation of web and mobile UI implementations
class PlatformScreenHelper {
  PlatformScreenHelper._();

  /// Returns the appropriate screen based on the platform
  ///
  /// Usage:
  /// ```dart
  /// PlatformScreenHelper.getScreen(
  ///   web: () => WebHomeScreen(),
  ///   mobile: () => MobileHomeScreen(),
  /// )
  /// ```
  static Widget getScreen({
    required Widget Function() web,
    required Widget Function() mobile,
  }) {
    if (kIsWeb) {
      return web();
    }
    return mobile();
  }

  /// Returns the appropriate widget based on the platform
  /// Alias for getScreen for better readability
  static Widget getWidget({
    required Widget Function() web,
    required Widget Function() mobile,
  }) {
    return getScreen(web: web, mobile: mobile);
  }

  /// Check if current platform is web
  static bool get isWeb => kIsWeb;

  /// Check if current platform is mobile (iOS/Android)
  static bool get isMobile => !kIsWeb;
}
