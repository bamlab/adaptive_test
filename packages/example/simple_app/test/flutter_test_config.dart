import 'dart:async';

import 'package:adaptive_test_extended/adaptive_test_extended.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app_example/generated/l10n.dart';

final defaultDeviceConfigs = {
  iPhone8,
  iPhone13,
  iPadPro,
  desktop,
  pixel5,
};

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance.setLocalizedDeviceVariants(
      defaultDeviceConfigs, AppLocalizations.delegate.supportedLocales);
  await loadFonts();
  const m1IntelDifferenceThreshold = 0.2 / 100; // 0.2%
  setupFileComparatorWithThreshold(m1IntelDifferenceThreshold);
  await testMain();
}
