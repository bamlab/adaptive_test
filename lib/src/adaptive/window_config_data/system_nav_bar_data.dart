import 'dart:ui';

import 'package:equatable/equatable.dart';

sealed class SystemNavBarData extends Equatable {
  const SystemNavBarData();

  /// Display the gesture indicator for the system navigation
  ///
  /// [bottom] The bottom offset of the indicator, expressed in `dp`.
  /// [size] The size of the indicator, expressed in `dp`.
  const factory SystemNavBarData.gestureIndicator(
    double bottom,
    Size size,
  ) = GestureIndicatorSystemNavBarData;

  /// Display the three-button navigation bar
  ///
  /// [height] The height of the navigation bar, expressed in `dp`.
  /// [backgroundColor] The background color of the navigation bar.
  /// [iconColor] The color of the icons in the navigation bar.
  /// [iconSize] The size of the icons in the navigation bar.
  /// [bottomPadding] The distance from the screen bottom to the navigation bar.
  const factory SystemNavBarData.threeButton({
    double height,
    Color backgroundColor,
    Color iconColor,
    double iconSize,
    double bottomPadding,
  }) = ThreeButtonSystemNavBarData;
}

/// Describe the OS gesture indicator on bottom of apps, expressed in `dp`.
///
/// This is null when the device has no gesture indicator.
class GestureIndicatorSystemNavBarData extends SystemNavBarData {
  const GestureIndicatorSystemNavBarData(this.bottom, this.size);

  /// Bottom offset of the indicator, expressed in `dp`.
  final double bottom;

  /// Size of the indicator, expressed in `dp`.
  final Size size;

  @override
  List<Object?> get props => [bottom, size];
}

/// Describe the OS three-button navigation bar.
///
/// This is null when the device does not use a three-button navigation bar.
/// Do not use with HomeIndicatorData.
class ThreeButtonSystemNavBarData extends SystemNavBarData {
  const ThreeButtonSystemNavBarData({
    this.height = 48.0,
    this.backgroundColor = const Color.fromRGBO(0, 0, 0, .1),
    this.iconColor = const Color.fromRGBO(40, 40, 40, .6),
    this.iconSize = 24.0,
    this.bottomPadding = 0.0,
  });

  /// Height of the navigation bar, expressed in `dp`.
  final double height;

  /// Background color of the navigation bar.
  final Color backgroundColor;

  /// Color of the icons in the navigation bar.
  final Color iconColor;

  /// Size of the icons in the navigation bar.
  final double iconSize;

  /// Distance from the screen bottom to the navigation bar.
  final double bottomPadding;

  @override
  List<Object?> get props => [
        height,
        backgroundColor,
        iconColor,
        iconSize,
        bottomPadding,
      ];
}
