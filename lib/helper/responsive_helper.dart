import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_grocery/main.dart';

class ResponsiveHelper {

  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    }else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile() {
    final size = MediaQuery.of(Get.context!).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size < 1300 && size >= 660) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery
        .of(context)
        .size
        .width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }

  // Enhanced breakpoint checks for web
  static bool isDesktopLarge(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size >= 1920 && kIsWeb;
  }

  static bool isLaptop(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size >= 1024 && size < 1300 && kIsWeb;
  }

  static bool isTabletLandscape(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size >= 768 && size < 1024 && kIsWeb;
  }

  static bool isTabletPortrait(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size >= 600 && size < 768 && kIsWeb;
  }

  static bool isMobileLarge(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size >= 480 && size < 600 && kIsWeb;
  }

  static bool isMobileSmall(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    return size < 480 && kIsWeb;
  }

  // Get current breakpoint as enum
  static ResponsiveBreakpoint getBreakpoint(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    if (!kIsWeb) return ResponsiveBreakpoint.mobileApp;
    if (size >= 1920) return ResponsiveBreakpoint.desktopLarge;
    if (size >= 1300) return ResponsiveBreakpoint.desktop;
    if (size >= 1024) return ResponsiveBreakpoint.laptop;
    if (size >= 768) return ResponsiveBreakpoint.tabletLandscape;
    if (size >= 600) return ResponsiveBreakpoint.tabletPortrait;
    if (size >= 480) return ResponsiveBreakpoint.mobileLarge;
    return ResponsiveBreakpoint.mobileSmall;
  }

  Future<void> showDialogOrBottomSheet(BuildContext context, Widget view, {bool isScrollControlled = true, bool isDismissible = true, bool enableDrag = true})  async {
    if(ResponsiveHelper.isDesktop(context)) {
      await showDialog(
        barrierDismissible: isDismissible,
        context: context, builder: (ctx)=> Center(child: view),
      );
    }else{
      await   showModalBottomSheet(
        isDismissible: isDismissible,
        enableDrag: enableDrag,
        backgroundColor: Colors.transparent,
        isScrollControlled: isScrollControlled,
        useSafeArea: true,
        context: context,
        builder: (ctx) => view,
      );
    }
  }
}

// Breakpoint enum for web responsiveness
enum ResponsiveBreakpoint {
  mobileApp,        // Native mobile app
  mobileSmall,      // < 480px
  mobileLarge,      // 480-599px
  tabletPortrait,   // 600-767px
  tabletLandscape,  // 768-1023px
  laptop,           // 1024-1299px
  desktop,          // 1300-1919px
  desktopLarge,     // >= 1920px
}