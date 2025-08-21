import 'dart:async';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final defaultDeviceConfigs = {
  iPhone8,
  iPhone16,
  iPadPro,
  desktop,
  pixel9,
  pixel5Alt,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  const m1IntelDifferenceThreshold = 0.2 / 100; // 0.2%
  setupFileComparatorWithThreshold(m1IntelDifferenceThreshold);
  await testMain();
}
