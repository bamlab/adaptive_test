import 'package:flutter_test/flutter_test.dart';

import 'window_size.dart';

/// Dart extension to add configuration functions to a [WidgetTester] object,
/// e.g. [configureWindow], [configureOpenedKeyboardWindow],
/// [configureClosedKeyboardWindow].
extension WidgetTesterWithConfigurableWindow on WidgetTester {
  /// Configure the tester window to represent the given device variant.
  void configureWindow(WindowConfigData windowConfig) {
    view.physicalSize = windowConfig.physicalSize;
    view.devicePixelRatio = windowConfig.pixelDensity;
    view.padding = windowConfig.padding;
    view.viewPadding = windowConfig.padding;
    if (windowConfig.locale != null) {
      view.platformDispatcher.localeTestValue = windowConfig.locale!;
    }
    addTearDown(() => view.platformDispatcher.clearLocaleTestValue());
    addTearDown(view.resetPadding);
    addTearDown(view.resetViewPadding);
    addTearDown(view.resetDevicePixelRatio);
    addTearDown(view.resetPhysicalSize);
    addTearDown(view.resetViewInsets);
  }

  /// Configure the tester window to represent an opened keyboard on the given device variant.
  void configureOpenedKeyboardWindow(WindowConfigData windowConfig) {
    view.viewInsets = windowConfig.viewInsets;
    view.padding = windowConfig.padding.copyWith(bottom: 0);
  }

  /// Configure the tester window to represent a closed keyboard on the given device variant.
  void configureClosedKeyboardWindow(WindowConfigData windowConfig) {
    view.resetViewInsets();
    view.padding = windowConfig.padding;
  }
}
