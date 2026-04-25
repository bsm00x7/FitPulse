import 'package:flutter/material.dart';

/// Responsive utilities for handling different screen sizes
class ResponsiveUtils {
  /// Device type enumeration
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 1024;
  static const double desktopMinWidth = 1024;

  /// Content max width for better tablet/desktop experience
  static const double contentMaxWidth = 1200;

  /// Get device type based on screen width
  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < mobileMaxWidth) {
      return DeviceType.mobile;
    } else if (width < tabletMaxWidth) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Check if current device is mobile
  static bool isMobile(BuildContext context) {
    return getDeviceType(context) == DeviceType.mobile;
  }

  /// Check if current device is tablet
  static bool isTablet(BuildContext context) {
    return getDeviceType(context) == DeviceType.tablet;
  }

  /// Check if current device is desktop
  static bool isDesktop(BuildContext context) {
    return getDeviceType(context) == DeviceType.desktop;
  }

  /// Get responsive font size
  static double getFontSize(BuildContext context, double baseSize) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSize;
      case DeviceType.tablet:
        return baseSize * 1.2;
      case DeviceType.desktop:
        return baseSize * 1.3;
    }
  }

  /// Get responsive spacing
  static double getSpacing(BuildContext context, double baseSpacing) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSpacing;
      case DeviceType.tablet:
        return baseSpacing * 1.5;
      case DeviceType.desktop:
        return baseSpacing * 2.0;
    }
  }

  /// Get responsive padding
  static EdgeInsets getHorizontalPadding(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return const EdgeInsets.symmetric(horizontal: 8);
      case DeviceType.tablet:
        return const EdgeInsets.symmetric(horizontal: 25);
      case DeviceType.desktop:
        return const EdgeInsets.symmetric(horizontal: 40);
    }
  }

  /// Get responsive width percentage
  static double getWidthPercentage(BuildContext context, double percentage) {
    final width = MediaQuery.of(context).size.width;
    return width * percentage;
  }

  /// Get responsive height percentage
  static double getHeightPercentage(BuildContext context, double percentage) {
    final height = MediaQuery.of(context).size.height;
    return height * percentage;
  }

  /// Get number of columns for grid layout
  static int getGridColumns(BuildContext context) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return 2;
      case DeviceType.tablet:
        return 3;
      case DeviceType.desktop:
        return 4;
    }
  }

  /// Get responsive container height
  static double getContainerHeight(BuildContext context, double baseHeight) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseHeight;
      case DeviceType.tablet:
        return baseHeight * 1.3;
      case DeviceType.desktop:
        return baseHeight * 1.5;
    }
  }

  /// Get responsive container width
  static double getContainerWidth(BuildContext context, double baseWidth) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseWidth;
      case DeviceType.tablet:
        return baseWidth * 1.3;
      case DeviceType.desktop:
        return baseWidth * 1.5;
    }
  }

  /// Get responsive icon size
  static double getIconSize(BuildContext context, double baseSize) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseSize;
      case DeviceType.tablet:
        return baseSize * 1.2;
      case DeviceType.desktop:
        return baseSize * 1.4;
    }
  }

  /// Get card width for activity cards
  static double getCardWidth(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final deviceType = getDeviceType(context);
    
    switch (deviceType) {
      case DeviceType.mobile:
        return (width - 60) / 2;
      case DeviceType.tablet:
        return (width - 103) / 3;
      case DeviceType.desktop:
        return (width - 150) / 4;
    }
  }

  /// Get responsive border radius
  static double getBorderRadius(BuildContext context, double baseRadius) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseRadius;
      case DeviceType.tablet:
        return baseRadius * 1.2;
      case DeviceType.desktop:
        return baseRadius * 1.3;
    }
  }

  /// Wrap content with max width constraint for better tablet/desktop experience
  static Widget constrainedContainer({
    required Widget child,
    double? maxWidth,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth ?? contentMaxWidth,
        ),
        child: child,
      ),
    );
  }
}

/// Device type enumeration
enum DeviceType {
  mobile,
  tablet,
  desktop,
}
