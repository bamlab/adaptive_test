import 'dart:io';

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

typedef SkipGoldenAssertion = bool Function();

class AdaptiveTestConfiguration {
  AdaptiveTestConfiguration._privateConstructor();

  static final AdaptiveTestConfiguration _instance =
      AdaptiveTestConfiguration._privateConstructor();

  static AdaptiveTestConfiguration get instance => _instance;

  WindowConfigDataCallback<String> get customDescribeValue =>
      _customDescribeValue ??
      (windowConfig) => windowConfig.themeMode == null
          ? windowConfig.name
          : '${windowConfig.name}:${windowConfig.themeMode!.name}';

  WindowConfigDataCallback<String>? _customDescribeValue;

  String Function(
          WindowConfigData windowConfig, Type widgetType, String? suffix)
      get fileNameFactory => _defaultGoldenFilePathFactory;

  /// a function indicating whether a golden assertion should be skipped
  SkipGoldenAssertion get skipGoldenAssertion => _skipGoldenAssertion;
  //default is DoNotSkipGoldenAssertion
  SkipGoldenAssertion _skipGoldenAssertion =
      () => !Platform.isMacOS && !Platform.version.contains('ARM64');

  void setCustomDescribeValue(WindowConfigDataCallback<String> callback) {
    _customDescribeValue = callback;
  }

  void setSkipGoldenChecker(SkipGoldenAssertion callback) {
    _skipGoldenAssertion = callback;
  }

  WindowVariant? _deviceVariant;
  WindowVariant? _themedDeviceVariant;

  WindowVariant get themedDeviceVariant {
    final scopedDeviceVariant = _themedDeviceVariant;
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
    final themedVariants = <WindowConfigData>{};
    for (final deviceConfig in deviceConfigs) {
      themedVariants.add(deviceConfig.light());
      themedVariants.add(deviceConfig.dark());
    }
    _themedDeviceVariant = WindowVariant(themedVariants);
  }

  void setLocalizedDeviceVariants(
      Set<WindowConfigData> deviceConfigs, List<Locale> locales) {
    final localizedDeviceConfigs = <WindowConfigData>{};

    final themedVariants = <WindowConfigData>{};
    for (final deviceConfig in deviceConfigs) {
      for (final locale in locales) {
        localizedDeviceConfigs.add(deviceConfig.copyWith(locale: locale));
        themedVariants.add(deviceConfig.light().copyWith(locale: locale));
        themedVariants.add(deviceConfig.dark().copyWith(locale: locale));
      }
    }
    _deviceVariant = WindowVariant(localizedDeviceConfigs);
    _themedDeviceVariant = WindowVariant(themedVariants);
  }

  /// Generates golden path for a given [WindowConfigData] and [Widget] type.
  String _defaultGoldenFilePathFactory(
      WindowConfigData windowConfig, Type widgetType, String? suffix) {
    final themeModeName = windowConfig.themeMode == null
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
      if (windowConfig.locale != null) windowConfig.locale!.languageCode,
      fileName,
    ].join('/');
  }
}
