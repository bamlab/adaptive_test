import 'dart:async';

import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

final defaultDeviceConfigs = {
  iPhone8,
  iPhone13,
  iPadPro,
  desktop,
  pixel5,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFontsFromPackage(
    package: Package(
      name: 'multi_packages_example_theme',
      relativePath: '../theme',
    ),
  );
  const m1IntelDifferenceThreshold = 0.2 / 100; // 0.2%
  setupFileComparatorWithThreshold(m1IntelDifferenceThreshold);
  await testMain();
}
