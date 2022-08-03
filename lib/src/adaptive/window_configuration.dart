import 'package:flutter_test/flutter_test.dart';

import 'window_size.dart';

/// Dart extension to add configuration functions to a [WidgetTester] object,
/// e.g. [configureWindow], [configureOpenedKeyboardWindow],
/// [configureClosedKeyboardWindow].
extension WidgetTesterWithConfigurableWindow on WidgetTester {
  /// Configure the tester window to represent the given device variant.
  void configureWindow(WindowConfigData windowConfig) {
    binding.window.physicalSizeTestValue = windowConfig.physicalSize;
    binding.window.devicePixelRatioTestValue = windowConfig.pixelDensity;
    binding.window.paddingTestValue = windowConfig.padding;
    binding.window.viewPaddingTestValue = windowConfig.padding;

    addTearDown(binding.window.clearPaddingTestValue);
    addTearDown(binding.window.clearViewPaddingTestValue);
    addTearDown(binding.window.clearPhysicalSizeTestValue);
    addTearDown(
      binding.window.clearDevicePixelRatioTestValue,
    );
    addTearDown(binding.window.clearViewInsetsTestValue);
  }

  /// Configure the tester window to represent an opened keyboard on the given device variant.
  void configureOpenedKeyboardWindow(WindowConfigData windowConfig) {
    binding.window.viewInsetsTestValue = windowConfig.viewInsets;
    binding.window.paddingTestValue = windowConfig.padding.copyWith(bottom: 0);
  }

  /// Configure the tester window to represent a closed keyboard on the given device variant.
  void configureClosedKeyboardWindow(WindowConfigData windowConfig) {
    binding.window.clearViewInsetsTestValue();
    binding.window.paddingTestValue = windowConfig.padding;
  }
}
