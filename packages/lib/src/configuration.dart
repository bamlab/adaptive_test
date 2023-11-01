import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import 'adaptive/window_size.dart';

/// Singleton class that configures global variables for the test.
///
/// Notably:
/// * `enforcedTestPlatform`, see [TargetPlatform].
/// * `deviceVariant`, see [WindowVariant] and [WindowConfigData].
///
/// Configure those variables in the [testExecutable] function inside the
/// `flutter_test_config.dart` file.
///
/// See: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
class AdaptiveTestConfiguration {
  AdaptiveTestConfiguration._privateConstructor();

  static final AdaptiveTestConfiguration _instance = AdaptiveTestConfiguration._privateConstructor();

  static AdaptiveTestConfiguration get instance => _instance;

  TargetPlatform? _enforcedTestPlatform;

  TargetPlatform? get enforcedTestPlatform => _enforcedTestPlatform;

  WindowConfigDataCallback<String> get customDescribeValue =>
      _customDescribeValue ??
      (windowConfig) => windowConfig.themeMode == null || windowConfig.themeMode == ThemeMode.system
          ? windowConfig.name
          : '${windowConfig.name}:${windowConfig.themeMode!.name}';

  WindowConfigDataCallback<String>? _customDescribeValue;

  String Function(WindowConfigData windowConfig, Type widgetType, String? suffix)? _fileNameFactory;
  String Function(WindowConfigData windowConfig, Type widgetType, String? suffix) get fileNameFactory =>
      _fileNameFactory ?? _defaultGoldenFilePathFactory;

  /// Images generated by golden test can have slight differences between the
  /// tests runtime platforms. Use this to enforce a specific platform across
  /// your team.
  ///
  /// Eg [TargetPlatform.linux], [TargetPlatform.macOS],
  /// [TargetPlatform.windows].
  void setEnforcedTestPlatform(TargetPlatform enforcedTestPlatform) {
    _enforcedTestPlatform = enforcedTestPlatform;
  }

  void setCustomDescribeValue(WindowConfigDataCallback<String> callback) {
    _customDescribeValue = callback;
  }

  WindowVariant? _deviceVariant;

  WindowVariant get deviceVariant {
    final scopedDeviceVariant = _deviceVariant;
    if (scopedDeviceVariant == null) {
      throw Exception(
        '''Device variant is not set.
please set it first in the [testExecutable] method.
See: https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
''',
      );
    }
    return scopedDeviceVariant;
  }

  /// Set the devices variant on which you want your test to run.
  ///
  /// Eg [iPhone8], [iPhone13], [iPadPro], [desktop], [pixel5].
  void setDeviceVariants(Set<WindowConfigData> deviceConfigs) {
    _deviceVariant = WindowVariant(deviceConfigs);
  }

  /// Generates golden path for a given [WindowConfigData] and [Widget] type.
  String _defaultGoldenFilePathFactory(WindowConfigData windowConfig, Type widgetType, String? suffix) {
    final themeModeName = windowConfig.themeMode == null || windowConfig.themeMode == ThemeMode.system
        ? ''
        : ':${windowConfig.themeMode!.name}';
    final localSuffix = suffix != null ? ReCase(suffix).snakeCase : '';
    const rootDirName = 'golden';
    String parentDirName = widgetType.toString().snakeCase;
    String fileName = '${windowConfig.name}$themeModeName.png';
    return [
      rootDirName,
      parentDirName,
      if (localSuffix.isNotEmpty) localSuffix,
      fileName,
    ].join('/');
  }
}
