import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:adaptive_test_extended/src/adaptive/window_size.dart';

void main() {
  group('WindowConfigData serialization test', () {
    final testDevice = WindowConfigData(
      'name',
      size: const Size(390, 844),
      pixelDensity: 3.0,
      safeAreaPadding: const EdgeInsets.only(top: 47, bottom: 34),
      keyboardSize: const Size(390, 302),
      borderRadius: BorderRadius.circular(48),
      homeIndicator: const HomeIndicatorData(8, Size(135, 5)),
      notchSize: const Size(154, 32),
      targetPlatform: TargetPlatform.iOS,
    );

    test('init', () {
      expect(testDevice.name, 'name');
      expect(testDevice.size, const Size(390, 844));
      expect(testDevice.pixelDensity, 3.0);
      expect(testDevice.themeMode, null);
      expect(testDevice.keyboardSize, const Size(390, 302));
      expect(testDevice.borderRadius, BorderRadius.circular(48));
      expect(
          testDevice.homeIndicator, const HomeIndicatorData(8, Size(135, 5)));
      expect(testDevice.notchSize, const Size(154, 32));
      expect(testDevice.targetPlatform, TargetPlatform.iOS);
      expect(testDevice.physicalSize, const Size(390, 844) * 3);

      final expectedPadding = const ViewPaddingImpl(bottom: 34, top: 47) * 3;
      expect(testDevice.padding.top, expectedPadding.top);
      expect(testDevice.padding.bottom, expectedPadding.bottom);
      expect(testDevice.padding.left, expectedPadding.left);
      expect(testDevice.padding.right, expectedPadding.right);

      final expectedViewInsets = const ViewPaddingImpl(bottom: 302) * 3;
      expect(testDevice.viewInsets.top, expectedViewInsets.top);
      expect(testDevice.viewInsets.bottom, expectedViewInsets.bottom);
      expect(testDevice.viewInsets.left, expectedViewInsets.left);
      expect(testDevice.viewInsets.right, expectedViewInsets.right);
    });

    test('light', () {
      final expectedLightTestDevice = testDevice.light();
      expect(expectedLightTestDevice.name, 'name');
      expect(expectedLightTestDevice.size, const Size(390, 844));
      expect(expectedLightTestDevice.pixelDensity, 3.0);
      expect(expectedLightTestDevice.themeMode, ThemeMode.light);
      expect(expectedLightTestDevice.keyboardSize, const Size(390, 302));
      expect(expectedLightTestDevice.borderRadius, BorderRadius.circular(48));
      expect(expectedLightTestDevice.homeIndicator,
          const HomeIndicatorData(8, Size(135, 5)));
      expect(expectedLightTestDevice.notchSize, const Size(154, 32));
      expect(expectedLightTestDevice.targetPlatform, TargetPlatform.iOS);
      expect(expectedLightTestDevice.physicalSize, const Size(390, 844) * 3);

      final expectedPadding = const ViewPaddingImpl(bottom: 34, top: 47) * 3;
      expect(expectedLightTestDevice.padding.top, expectedPadding.top);
      expect(expectedLightTestDevice.padding.bottom, expectedPadding.bottom);
      expect(expectedLightTestDevice.padding.left, expectedPadding.left);
      expect(expectedLightTestDevice.padding.right, expectedPadding.right);

      final expectedViewInsets = const ViewPaddingImpl(bottom: 302) * 3;
      expect(expectedLightTestDevice.viewInsets.top, expectedViewInsets.top);
      expect(
          expectedLightTestDevice.viewInsets.bottom, expectedViewInsets.bottom);
      expect(expectedLightTestDevice.viewInsets.left, expectedViewInsets.left);
      expect(
          expectedLightTestDevice.viewInsets.right, expectedViewInsets.right);
    });

    test('dark', () {
      final expectedLightTestDevice = testDevice.dark();
      expect(expectedLightTestDevice.name, 'name');
      expect(expectedLightTestDevice.size, const Size(390, 844));
      expect(expectedLightTestDevice.pixelDensity, 3.0);
      expect(expectedLightTestDevice.themeMode, ThemeMode.dark);
      expect(expectedLightTestDevice.keyboardSize, const Size(390, 302));
      expect(expectedLightTestDevice.borderRadius, BorderRadius.circular(48));
      expect(expectedLightTestDevice.homeIndicator,
          const HomeIndicatorData(8, Size(135, 5)));
      expect(expectedLightTestDevice.notchSize, const Size(154, 32));
      expect(expectedLightTestDevice.targetPlatform, TargetPlatform.iOS);
      expect(expectedLightTestDevice.physicalSize, const Size(390, 844) * 3);

      final expectedPadding = const ViewPaddingImpl(bottom: 34, top: 47) * 3;
      expect(expectedLightTestDevice.padding.top, expectedPadding.top);
      expect(expectedLightTestDevice.padding.bottom, expectedPadding.bottom);
      expect(expectedLightTestDevice.padding.left, expectedPadding.left);
      expect(expectedLightTestDevice.padding.right, expectedPadding.right);

      final expectedViewInsets = const ViewPaddingImpl(bottom: 302) * 3;
      expect(expectedLightTestDevice.viewInsets.top, expectedViewInsets.top);
      expect(
          expectedLightTestDevice.viewInsets.bottom, expectedViewInsets.bottom);
      expect(expectedLightTestDevice.viewInsets.left, expectedViewInsets.left);
      expect(
          expectedLightTestDevice.viewInsets.right, expectedViewInsets.right);
    });
  });
}
