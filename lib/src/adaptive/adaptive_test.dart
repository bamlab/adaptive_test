import 'dart:io';

import 'package:adaptive_test/src/adaptive/widgets/adaptive_wrapper.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/window_config_data.dart';
import 'package:adaptive_test/src/adaptive/window_configuration_tester.dart';
import 'package:adaptive_test/src/configuration.dart';
import 'package:adaptive_test/src/helpers/await_images.dart';
import 'package:adaptive_test/src/helpers/skip_test_extension.dart';
import 'package:adaptive_test/src/helpers/target_platform_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

/// Type of [callback] that will be executed inside the Flutter test
/// environment.
///
/// Take a [WidgetTester] and a [WindowConfigData] for arguments.
typedef WidgetTesterAdaptiveCallback = Future<void> Function(
  WidgetTester widgetTester,
  WindowConfigData windowConfig,
);

/// Function wrapper around [testWidgets] that will be executed for every
/// [WindowConfigData] variant.
@isTest
void testAdaptiveWidgets(
  String description,
  WidgetTesterAdaptiveCallback callback, {
  /// If true, the test will be skipped. Defaults to false.
  /// If [enforcedTestPlatform] is defined in the [AdaptiveTestConfiguration]
  /// and [failTestOnWrongPlatform] is false, the test will be skipped if the
  /// runtime platform does not match the [enforcedTestPlatform].
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  ValueVariant<WindowConfigData>? variantOverride,
  // ignore: avoid-dynamic, argument type of testWidgets
  dynamic tags,
}) {
  final configuration = AdaptiveTestConfiguration.instance;
  final defaultVariant = configuration.deviceVariant;
  final variant = variantOverride ?? defaultVariant;

  final _skip = skip ?? configuration.shouldSkipTest;

  testWidgets(
    description,
    (tester) async {
      // ignore: avoid-non-null-assertion, will throw in test
      debugDefaultTargetPlatformOverride = variant.currentValue!.targetPlatform;
      debugDisableShadows = false;
      // ignore: avoid-non-null-assertion, will throw in test
      tester.configureWindow(variant.currentValue!);
      // ignore: avoid-non-null-assertion, will throw in test
      await callback(tester, variant.currentValue!);
      debugDisableShadows = true;
      debugDefaultTargetPlatformOverride = null;
    },
    skip: _skip,
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    variant: variant,
    tags: tags,
  );
}

/// Extend [WidgetTester] with the [expectGolden] method, providing the ability
/// to assert golden matching for a given [WindowConfigData].
///
/// Golden file previews are stored within the "preview" folder.
///
/// Because adaptive rendering depends on the targeted platform, we need to make
/// sure the platform running the current test matches the
/// [enforcedTestPlatform] defined in the [AdaptiveTestConfiguration].
extension Adaptive on WidgetTester {
  /// Visual regression test for a given [WindowConfigData].
  ///
  /// The [suffix] is appended to the golden file name. It defaults to
  /// the empty string if not provided.
  ///
  /// By default, the path of the generated golden file is constructed as
  /// follows:
  /// `preview/${windowConfig.name}-${name.snakeCase}$localSuffix.png`.
  /// If a [path] is provided, it will override this default behavior.
  ///
  /// The [byKey] argument allows the test to find the widget by its unique key,
  /// which is useful when multiple widgets of the same type are present.
  ///
  /// The [version] argument is an optional integer that can be used to
  /// differentiate historical golden files.
  ///
  /// Set [waitForImages] to `false` if you want to skip waiting for all images
  /// to load before taking the snapshot. By default, it waits for all images to
  /// load.
  @isTest
  Future<void> expectGolden<T>(
    WindowConfigData windowConfig, {
    String? suffix,
    String? path,
    Key? byKey,
    int? version,
    bool waitForImages = true,
  }) async {
    final enforcedTestPlatform =
        AdaptiveTestConfiguration.instance.enforcedTestPlatform;
    if (enforcedTestPlatform != null &&
        !enforcedTestPlatform.isRuntimePlatform) {
      throw Exception(
        'Runtime platform ${Platform.operatingSystem}'
        ' is not ${enforcedTestPlatform.name}',
      );
    }

    final localSuffix = suffix != null ? '_${ReCase(suffix).snakeCase}' : '';

    final name = ReCase('$T');
    if (waitForImages) {
      await awaitImages();
    }

    final key = path ??
        'preview/${windowConfig.name}-${name.snakeCase}$localSuffix.png';
    await expectLater(
      // Find by its type except if the widget's unique key was given.
      byKey != null ? find.byKey(byKey) : find.byType(AdaptiveWrapper),
      matchesGoldenFile(key, version: version),
    );
  }
}
