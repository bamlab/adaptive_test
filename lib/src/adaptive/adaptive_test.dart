import 'dart:io';

import 'package:adaptive_test/src/adaptive/window_configuration.dart';
import 'package:adaptive_test/src/adaptive/window_size.dart';
import 'package:adaptive_test/src/configuration.dart';
import 'package:adaptive_test/src/helpers/await_images.dart';
import 'package:adaptive_test/src/helpers/skip_test_extension.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import 'package:recase/recase.dart';

import '../helpers/target_platform_extension.dart';
import 'widgets/adaptive_wrapper.dart';

/// Type of [callback] that will be executed inside the Flutter test environment.
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
  dynamic tags,
}) {
  final configuration = AdaptiveTestConfiguration.instance;
  final defaultVariant = configuration.deviceVariant;
  final variant = variantOverride ?? defaultVariant;

  skip = skip ?? configuration.shouldSkipTest;

  testWidgets(
    description,
    (tester) async {
      debugDefaultTargetPlatformOverride = variant.currentValue!.targetPlatform;
      debugDisableShadows = false;
      tester.configureWindow(variant.currentValue!);
      await callback(tester, variant.currentValue!);
      debugDisableShadows = true;
      debugDefaultTargetPlatformOverride = null;
    },
    skip: skip,
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
  @isTest
  Future<void> expectGolden<T>(
    WindowConfigData windowConfig, {
    String? suffix,
    Key?
        byKey, // Sometimes we want to find the widget by its unique key in the case they are multiple of the same type.
    bool waitForImages = true,
  }) async {
    final enforcedTestPlatform =
        AdaptiveTestConfiguration.instance.enforcedTestPlatform;
    if (enforcedTestPlatform != null &&
        !enforcedTestPlatform.isRuntimePlatform) {
      throw ('Runtime platform ${Platform.operatingSystem} is not ${enforcedTestPlatform.name}');
    }

    final localSuffix = suffix != null ? "_${ReCase(suffix).snakeCase}" : '';

    final name = ReCase('$T');
    if (waitForImages) {
      await awaitImages();
    }
    await expectLater(
      // Find by its type except if the widget's unique key was given.
      byKey != null ? find.byKey(byKey) : find.byType(AdaptiveWrapper),
      matchesGoldenFile(
        'preview/${windowConfig.name}-${name.snakeCase}$localSuffix.png',
      ),
    );
  }
}
