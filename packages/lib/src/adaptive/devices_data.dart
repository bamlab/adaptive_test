// ignore_for_file: unused_field, constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'window_size.dart';

enum _Device {
  iPhone_8,
  iPhone_13,
  iPadPro,
  Desktop,
  Pixel_5,
}

/// [WindowConfigData] for an iPhone 8.
final WindowConfigData iPhone8 = WindowConfigData(
  _Device.iPhone_8.name,
  size: const Size(375, 667),
  pixelDensity: 2.0,
  safeAreaPadding: EdgeInsets.zero,
  keyboardSize: const Size(375, 218),
  borderRadius: BorderRadius.zero,
  targetPlatform: TargetPlatform.iOS,
);

/// [WindowConfigData] for an iPhone 13.
final WindowConfigData iPhone13 = WindowConfigData(
  _Device.iPhone_13.name,
  size: const Size(390, 844),
  pixelDensity: 3.0,
  safeAreaPadding: const EdgeInsets.only(top: 47, bottom: 34),
  keyboardSize: const Size(390, 302),
  borderRadius: BorderRadius.circular(48),
  homeIndicator: const HomeIndicatorData(8, Size(135, 5)),
  notchSize: const Size(154, 32),
  targetPlatform: TargetPlatform.iOS,
);

/// [WindowConfigData] for a Google Pixel 5.
final WindowConfigData pixel5 = WindowConfigData(
  _Device.Pixel_5.name,
  size: const Size(360, 764),
  pixelDensity: 3.0,
  safeAreaPadding: const EdgeInsets.only(top: 24),
  keyboardSize: const Size(360, 297),
  borderRadius: BorderRadius.circular(32),
  homeIndicator: const HomeIndicatorData(8, Size(72, 2)),
  targetPlatform: TargetPlatform.android,
  punchHole: const PunchHoleData(Offset(12, 12), 25),
);

/// [WindowConfigData] for a 12.9" iPad Pro.
final WindowConfigData iPadPro = WindowConfigData(
  _Device.iPadPro.name,
  size: const Size(1366, 1024),
  pixelDensity: 2.0,
  safeAreaPadding: const EdgeInsets.only(top: 24, bottom: 20),
  keyboardSize: const Size(1366, 420),
  borderRadius: BorderRadius.circular(24),
  homeIndicator: const HomeIndicatorData(8, Size(315, 5)),
  targetPlatform: TargetPlatform.iOS,
);

/// [WindowConfigData] for a basic 1080p web or desktop window.
final WindowConfigData desktop = WindowConfigData(
  _Device.Desktop.name,
  size: const Size(1920, 1080),
  pixelDensity: 1.0,
  safeAreaPadding: EdgeInsets.zero,
  borderRadius: BorderRadius.zero,
  targetPlatform: TargetPlatform.linux,
);
