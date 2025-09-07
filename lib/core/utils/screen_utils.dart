import 'package:flutter/material.dart';

class ScreenUtils {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double statusBarHeight;
  static late double bottomBarHeight;
  static late double appBarHeight;
  static late double keyboardHeight;
  static late bool isKeyboardVisible;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    statusBarHeight = _mediaQueryData.padding.top;
    bottomBarHeight = _mediaQueryData.padding.bottom;
    appBarHeight = kToolbarHeight;
    keyboardHeight = _mediaQueryData.viewInsets.bottom;
    isKeyboardVisible = keyboardHeight > 0;
  }

  // Responsive width
  static double getWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  // Responsive height
  static double getHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  // Safe area responsive width
  static double getSafeWidth(double percentage) {
    return (screenWidth - _safeAreaHorizontal) * (percentage / 100);
  }

  // Safe area responsive height
  static double getSafeHeight(double percentage) {
    return (screenHeight - _safeAreaVertical) * (percentage / 100);
  }

  // Responsive font size
  static double getFontSize(double baseFontSize) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.85; // Small phones
    } else if (screenWidth < 414) {
      scaleFactor = 0.95; // Medium phones
    } else if (screenWidth < 768) {
      scaleFactor = 1.0; // Large phones
    } else if (screenWidth < 1024) {
      scaleFactor = 1.1; // Tablets
    } else {
      scaleFactor = 1.2; // Large tablets/desktop
    }
    
    return baseFontSize * scaleFactor;
  }

  // Responsive padding
  static EdgeInsets getPadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.8; // Small phones
    } else if (screenWidth < 414) {
      scaleFactor = 0.9; // Medium phones
    } else if (screenWidth < 768) {
      scaleFactor = 1.0; // Large phones
    } else if (screenWidth < 1024) {
      scaleFactor = 1.1; // Tablets
    } else {
      scaleFactor = 1.2; // Large tablets/desktop
    }

    return EdgeInsets.only(
      top: (top ?? vertical ?? all ?? 0) * scaleFactor,
      bottom: (bottom ?? vertical ?? all ?? 0) * scaleFactor,
      left: (left ?? horizontal ?? all ?? 0) * scaleFactor,
      right: (right ?? horizontal ?? all ?? 0) * scaleFactor,
    );
  }

  // Responsive margin
  static EdgeInsets getMargin({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return getPadding(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }

  // Responsive border radius
  static double getRadius(double baseRadius) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.8;
    } else if (screenWidth < 414) {
      scaleFactor = 0.9;
    } else if (screenWidth < 768) {
      scaleFactor = 1.0;
    } else if (screenWidth < 1024) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.2;
    }
    
    return baseRadius * scaleFactor;
  }

  // Device type detection
  static bool get isSmallPhone => screenWidth < 360;
  static bool get isMediumPhone => screenWidth >= 360 && screenWidth < 414;
  static bool get isLargePhone => screenWidth >= 414 && screenWidth < 768;
  static bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  static bool get isLargeTablet => screenWidth >= 1024;

  // Orientation detection
  static bool get isPortrait => screenHeight > screenWidth;
  static bool get isLandscape => screenWidth > screenHeight;

  // Grid columns based on screen size
  static int getGridColumns() {
    if (isSmallPhone) return 1;
    if (isMediumPhone) return 2;
    if (isLargePhone) return 2;
    if (isTablet) return 3;
    return 4;
  }

  // Card aspect ratio based on screen size
  static double getCardAspectRatio() {
    if (isSmallPhone) return 1.5;
    if (isMediumPhone) return 1.3;
    if (isLargePhone) return 1.2;
    if (isTablet) return 1.1;
    return 1.0;
  }

  // Icon size based on screen size
  static double getIconSize(double baseSize) {
    if (isSmallPhone) return baseSize * 0.8;
    if (isMediumPhone) return baseSize * 0.9;
    if (isLargePhone) return baseSize;
    if (isTablet) return baseSize * 1.1;
    return baseSize * 1.2;
  }

  // Button height based on screen size
  static double getButtonHeight() {
    if (isSmallPhone) return 44;
    if (isMediumPhone) return 48;
    if (isLargePhone) return 52;
    if (isTablet) return 56;
    return 60;
  }

  // App bar height based on screen size
  static double getAppBarHeight() {
    if (isSmallPhone) return 48;
    if (isMediumPhone) return 52;
    if (isLargePhone) return 56;
    if (isTablet) return 60;
    return 64;
  }

  // Logo size based on screen size
  static double getLogoSize() {
    if (isSmallPhone) return 100;
    if (isMediumPhone) return 120;
    if (isLargePhone) return 140;
    if (isTablet) return 160;
    return 180;
  }

  // Compact logo size based on screen size
  static double getCompactLogoSize() {
    if (isSmallPhone) return 24;
    if (isMediumPhone) return 28;
    if (isLargePhone) return 32;
    if (isTablet) return 36;
    return 40;
  }
}

// Extension for easy access to responsive values
extension ResponsiveExtension on BuildContext {
  ScreenUtils get screenUtils => ScreenUtils();
  
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  
  bool get isSmallPhone => screenWidth < 360;
  bool get isMediumPhone => screenWidth >= 360 && screenWidth < 414;
  bool get isLargePhone => screenWidth >= 414 && screenWidth < 768;
  bool get isTablet => screenWidth >= 768 && screenWidth < 1024;
  bool get isLargeTablet => screenWidth >= 1024;
  
  bool get isPortrait => screenHeight > screenWidth;
  bool get isLandscape => screenWidth > screenHeight;
  
  double responsiveWidth(double percentage) => screenWidth * (percentage / 100);
  double responsiveHeight(double percentage) => screenHeight * (percentage / 100);
  
  double responsiveFontSize(double baseFontSize) {
    double scaleFactor = 1.0;
    
    if (screenWidth < 360) {
      scaleFactor = 0.85;
    } else if (screenWidth < 414) {
      scaleFactor = 0.95;
    } else if (screenWidth < 768) {
      scaleFactor = 1.0;
    } else if (screenWidth < 1024) {
      scaleFactor = 1.1;
    } else {
      scaleFactor = 1.2;
    }
    
    return baseFontSize * scaleFactor;
  }
  
  EdgeInsets responsivePadding({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    return ScreenUtils.getPadding(
      all: all,
      horizontal: horizontal,
      vertical: vertical,
      top: top,
      bottom: bottom,
      left: left,
      right: right,
    );
  }
}

