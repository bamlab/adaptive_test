import 'package:adaptive_test/src/adaptive/window_config_data/window_config_data.dart';
import 'package:flutter_test/flutter_test.dart';

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
    view.viewPadding = windowConfig.viewInsets;
  }

  /// Configure the tester window to represent a closed keyboard on the given device variant.
  void configureClosedKeyboardWindow(WindowConfigData windowConfig) {
    view.resetViewInsets();
    view.padding = windowConfig.padding;
    view.viewPadding = windowConfig.padding;
  }
}
