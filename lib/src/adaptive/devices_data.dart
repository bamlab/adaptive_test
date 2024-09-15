import 'package:adaptive_test/src/adaptive/window_size.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

enum _Device {
  iPhone_8,
  iPhone_13,
  iPadPro,
  desktop,
  pixel_5;

  String get keyboardName => 'assets/keyboards/${this.name}.png';
}

/// [WindowConfigData] for an iPhone 8.
final WindowConfigData iPhone8 = WindowConfigData(
  _Device.iPhone_8.name,
  size: const Size(375, 667),
  pixelDensity: 2,
  safeAreaPadding: EdgeInsets.zero,
  keyboardSize: const Size(375, 218),
  borderRadius: BorderRadius.zero,
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPhone_8.keyboardName,
);

/// [WindowConfigData] for an iPhone 13.
final WindowConfigData iPhone13 = WindowConfigData(
  _Device.iPhone_13.name,
  size: const Size(390, 844),
  pixelDensity: 3,
  safeAreaPadding: const EdgeInsets.only(top: 47, bottom: 34),
  keyboardSize: const Size(390, 302),
  borderRadius: const BorderRadius.all(
    Radius.circular(48),
  ),
  homeIndicator: const HomeIndicatorData(8, Size(135, 5)),
  notchSize: const Size(154, 32),
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPhone_13.keyboardName,
);

/// [WindowConfigData] for a Google Pixel 5.
final WindowConfigData pixel5 = WindowConfigData(
  _Device.pixel_5.name,
  size: const Size(360, 764),
  pixelDensity: 3,
  safeAreaPadding: const EdgeInsets.only(top: 24),
  keyboardSize: const Size(360, 297),
  borderRadius: const BorderRadius.all(
    Radius.circular(32),
  ),
  homeIndicator: const HomeIndicatorData(8, Size(72, 2)),
  targetPlatform: TargetPlatform.android,
  punchHole: const PunchHoleData(Offset(12, 12), 25),
  keyboardName: _Device.pixel_5.keyboardName,
);

/// [WindowConfigData] for a 12.9" iPad Pro.
final WindowConfigData iPadPro = WindowConfigData(
  _Device.iPadPro.name,
  size: const Size(1366, 1024),
  pixelDensity: 2,
  safeAreaPadding: const EdgeInsets.only(top: 24, bottom: 20),
  keyboardSize: const Size(1366, 420),
  borderRadius: const BorderRadius.all(
    Radius.circular(24),
  ),
  homeIndicator: const HomeIndicatorData(8, Size(315, 5)),
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPadPro.keyboardName,
);

/// [WindowConfigData] for a basic 1080p web or desktop window.
final WindowConfigData desktop = WindowConfigData(
  _Device.desktop.name,
  size: const Size(1920, 1080),
  pixelDensity: 1,
  safeAreaPadding: EdgeInsets.zero,
  borderRadius: BorderRadius.zero,
  targetPlatform: TargetPlatform.linux,
  keyboardName: _Device.desktop.keyboardName,
);
