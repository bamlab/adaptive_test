import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Describe the OS gesture indicator on bottom of apps, expressed in `dp`.
///
/// This is null when the device has no gesture indicator.
class HomeIndicatorData extends Equatable {
  const HomeIndicatorData(this.bottom, this.size);

  /// Bottom offset of the indicator, expressed in `dp`.
  final double bottom;

  /// Size of the indicator, expressed in `dp`.
  final Size size;

  @override
  List<Object?> get props => [bottom, size];
}
