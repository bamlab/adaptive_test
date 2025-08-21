import 'package:adaptive_test/src/adaptive/window_config_data/dynamic_island_data.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/punch_hole_data.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A Data class that describe a device properties that will impact design.
class WindowConfigData extends Equatable {
  WindowConfigData(
    this.name, {
    required this.size,
    required this.pixelDensity,
    required this.targetPlatform,
    required this.borderRadius,
    required EdgeInsets safeAreaPadding,
    required this.keyboardName,
    this.keyboardPackage,
    this.keyboardSize,
    this.notchSize,
    this.dynamicIsland,
    this.punchHole,
    this.systemNavBar,
  })  : viewInsets = ViewPaddingImpl(
              bottom: keyboardSize?.height ?? 0,
            ) *
            pixelDensity,
        padding = ViewPaddingImpl(
              bottom: safeAreaPadding.bottom,
              top: safeAreaPadding.top,
            ) *
            pixelDensity,
        physicalSize = size * pixelDensity;

  final String name;

  /// Describes the size of the physical screen of the device in `dp`.
  final Size size;

  /// Describe the pixel density of the device.
  ///
  /// For iOS, this translates to the `@2x` and `@3x` annotations.
  final double pixelDensity;

  /// Describes the size of virtual keyboard of the device in `dp`.
  ///
  /// This is null when the device hasn't a virtual keyboard
  final Size? keyboardSize;

  /// Describe the size of the device physical screen top notch in `dp`.
  ///
  /// This is null when the device has no notch.
  final Size? notchSize;

  /// Describe the size of the device physical screen top dynamic island in `dp`.
  ///
  /// This is null when the device has no dynamic island.
  final DynamicIslandData? dynamicIsland;

  /// Describe the size of the device physical screen camera punch hole in `dp`.
  ///
  /// This is null when the device has no punch hole.
  /// See: [PunchHoleData]
  final PunchHoleData? punchHole;

  /// Describe the OS system navigation bar on bottom of apps
  ///
  /// This is null when the device has no navigation bar.
  final SystemNavBarData? systemNavBar;

  /// Device Platform.
  ///
  /// See: [TargetPlatform]
  final TargetPlatform targetPlatform;

  /// This border radius describe the physical rounded corner of a device.
  final BorderRadius borderRadius;

  /// This padding describe the size used by an opened keyboard.
  ///
  /// expressed in `px`.
  final FakeViewPadding viewInsets;

  /// This padding describe the size taken by the hardware layer.
  /// Like the notch on the iPhone X.
  ///
  /// expressed in `px`.
  final FakeViewPadding padding;

  /// This represent the size of the device, expressed in `px`.
  final Size physicalSize;

  /// Name of the image asset that represent the keyboard.
  final String keyboardName;

  /// Package where the keyboard asset file is located. Keep to null if the
  /// asset is located in your app.
  final String? keyboardPackage;

  @override
  List<Object?> get props => [
        name,
        size,
        pixelDensity,
        keyboardSize,
        notchSize,
        punchHole,
        systemNavBar,
        targetPlatform,
        borderRadius,
        viewInsets,
        padding,
        physicalSize,
        keyboardName,
        keyboardPackage,
        dynamicIsland,
      ];
}

/// Implementation of the abstract class [FakeViewPadding].
class ViewPaddingImpl implements FakeViewPadding {
  const ViewPaddingImpl({
    this.bottom = 0,
    this.top = 0,
    this.left = 0,
    this.right = 0,
  });

  static const ViewPaddingImpl zero = ViewPaddingImpl();

  @override
  final double bottom;

  @override
  final double top;

  @override
  final double left;

  @override
  final double right;

  /// Multiplication operator.
  ///
  /// Returns a [WindowPaddingImpl] whose dimensions are the dimensions of the
  /// left-hand-side operand (a [WindowPaddingImpl]) multiplied by the scalar
  /// right-hand-side operand (a [double]).
  ViewPaddingImpl operator *(double operand) => ViewPaddingImpl(
        bottom: bottom * operand,
        top: top * operand,
        left: left * operand,
        right: right * operand,
      );
}

extension FakeViewPaddingX on FakeViewPadding {
  FakeViewPadding copyWith({
    double? bottom,
    double? top,
    double? left,
    double? right,
  }) {
    return ViewPaddingImpl(
      bottom: bottom ?? this.bottom,
      top: top ?? this.top,
      left: left ?? this.left,
      right: right ?? this.right,
    );
  }
}
