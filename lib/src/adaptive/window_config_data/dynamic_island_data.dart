import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Describe the dynamic island on top of apps, expressed in `dp`.
///
/// This is null when the device has no dynamic island.
class DynamicIslandData extends Equatable {
  const DynamicIslandData(this.top, this.size);

  /// top offset of the indicator, expressed in `dp`.
  final double top;

  /// Size of the indicator, expressed in `dp`.
  final Size size;

  @override
  List<Object?> get props => [top, size];
}
