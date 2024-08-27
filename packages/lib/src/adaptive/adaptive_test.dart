import 'window_size.dart';
import '../configuration.dart';
import '../helpers/await_images.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';
import './window_configuration.dart';
import 'widgets/adaptive_wrapper.dart';

/// Type of [callback] that will be executed inside the Flutter test environment.
///
/// Take a [WidgetTester] and a [WindowConfigData] for arguments.
typedef WidgetTesterAdaptiveCallback = Future<void> Function(
  WidgetTester widgetTester,
  WindowConfigData windowConfig,
);

const _defaultGoldenTag = ['golden'];

/// Function wrapper around [testWidgets] that will be executed for every
/// [WindowConfigData] variant.
@isTest
void testAdaptiveThemedWidgets(
  String description,
  WidgetTesterAdaptiveCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  ValueVariant<WindowConfigData>? variantOverride,
  dynamic tags,
}) {
  final variant =
      variantOverride ?? AdaptiveTestConfiguration.instance.themedDeviceVariant;

  _testAdaptiveWidgetsBase(
    description,
    (widgetTester, windowConfig) => callback(
      widgetTester,
      windowConfig,
    ),
    variant,
    skip: skip ?? AdaptiveTestConfiguration.instance.skipGoldenAssertion(),
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    tags: tags ?? _defaultGoldenTag,
  );
}

@isTest
void testAdaptiveWidgets(
  String description,
  WidgetTesterAdaptiveCallback callback, {
  bool? skip,
  Timeout? timeout,
  bool semanticsEnabled = true,
  ValueVariant<WindowConfigData>? variantOverride,
  dynamic tags,
}) {
  final defaultVariant = AdaptiveTestConfiguration.instance.deviceVariant;
  final variant = variantOverride ?? defaultVariant;
  _testAdaptiveWidgetsBase(
    description,
    callback,
    variant,
    skip: skip ?? AdaptiveTestConfiguration.instance.skipGoldenAssertion(),
    timeout: timeout,
    semanticsEnabled: semanticsEnabled,
    tags: tags ?? _defaultGoldenTag,
  );
}

@isTest
void _testAdaptiveWidgetsBase(
  String description,
  WidgetTesterAdaptiveCallback callback,
  ValueVariant<WindowConfigData> variant, {
  required bool skip,
  required Timeout? timeout,
  required bool semanticsEnabled,
  required dynamic tags,
}) {
  testWidgets(
    description,
    (tester) async {
      if (variant.currentValue?.themeMode == ThemeMode.dark) {
        tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      } else {
        tester.platformDispatcher.platformBrightnessTestValue =
            Brightness.light;
      }
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
    tags: tags ?? _defaultGoldenTag,
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
    Future<void> Function(WidgetTester tester, WindowConfigData windowConfig)?
        onDeviceSetup,
  }) async {
    if (waitForImages) {
      await awaitImages();
    }

    await onDeviceSetup?.call(this, windowConfig);
    await expectLater(
      // Find by its type except if the widget's unique key was given.
      byKey != null ? find.byKey(byKey) : find.byType(AdaptiveWrapper),
      matchesGoldenFile(
        AdaptiveTestConfiguration.instance
            .fileNameFactory(windowConfig, T, suffix),
      ),
    );
  }
}
