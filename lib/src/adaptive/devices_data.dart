import 'package:adaptive_test/src/adaptive/window_config_data/dynamic_island_data.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/punch_hole_data.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/window_config_data.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

enum _Device {
  iPhone_8,
  iPhone_13,
  iPhone_16,
  iPadPro,
  desktop,
  pixel_5,
  pixel_9;

  String get keyboardName => 'assets/keyboards/${this.name}.png';
}

const _keyboardPackage = 'adaptive_test';

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
  keyboardPackage: _keyboardPackage,
);

/// [WindowConfigData] for an iPhone 13.
final WindowConfigData iPhone13 = WindowConfigData(
  _Device.iPhone_13.name,
  size: const Size(390, 844),
  pixelDensity: 3,
  safeAreaPadding: const EdgeInsets.only(top: 47, bottom: 34),
  keyboardSize: const Size(390, 336),
  borderRadius: const BorderRadius.all(
    Radius.circular(47),
  ),
  systemNavBar: const SystemNavBarData.gestureIndicator(8, Size(139, 5)),
  notchSize: const Size(154, 32),
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPhone_13.keyboardName,
  keyboardPackage: _keyboardPackage,
);

/// [WindowConfigData] for an iPhone 16.
final WindowConfigData iPhone16 = WindowConfigData(
  _Device.iPhone_16.name,
  size: const Size(393, 852),
  pixelDensity: 3,
  safeAreaPadding: const EdgeInsets.only(top: 59, bottom: 34),
  keyboardSize: const Size(393, 336),
  borderRadius: const BorderRadius.all(
    Radius.circular(55),
  ),
  systemNavBar: const SystemNavBarData.gestureIndicator(8, Size(140, 5)),
  dynamicIsland: DynamicIslandData(11, Size(125, 37)),
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPhone_16.keyboardName,
  keyboardPackage: _keyboardPackage,
);

/// [WindowConfigData] for a Google Pixel 5.
final WindowConfigData pixel5 = WindowConfigData(
  _Device.pixel_5.name,
  size: const Size(392, 850),
  pixelDensity: 2.75,
  safeAreaPadding: const EdgeInsets.only(top: 49, bottom: 24),
  keyboardSize: const Size(392, 302),
  borderRadius: const BorderRadius.all(
    Radius.circular(32),
  ),
  systemNavBar: const SystemNavBarData.gestureIndicator(8, Size(72, 2)),
  targetPlatform: TargetPlatform.android,
  punchHole: const PunchHoleData(Offset(12, 12), 25),
  keyboardName: _Device.pixel_5.keyboardName,
  keyboardPackage: _keyboardPackage,
);

/// [WindowConfigData] for a Google Pixel 9.
final WindowConfigData pixel9 = WindowConfigData(
  _Device.pixel_9.name,
  size: const Size(412, 923),
  pixelDensity: 2.625,
  safeAreaPadding: const EdgeInsets.only(top: 51, bottom: 24),
  keyboardSize: const Size(412, 360),
  borderRadius: const BorderRadius.all(
    Radius.circular(55),
  ),
  systemNavBar: const SystemNavBarData.gestureIndicator(10, Size(108, 4)),
  targetPlatform: TargetPlatform.android,
  punchHole: const PunchHoleData(Offset(190, 17), 31),
  keyboardName: _Device.pixel_9.keyboardName,
  keyboardPackage: _keyboardPackage,
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
  systemNavBar: const SystemNavBarData.gestureIndicator(8, Size(315, 5)),
  targetPlatform: TargetPlatform.iOS,
  keyboardName: _Device.iPadPro.keyboardName,
  keyboardPackage: _keyboardPackage,
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
  keyboardPackage: _keyboardPackage,
);
