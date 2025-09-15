import 'dart:ui';

import 'package:equatable/equatable.dart';

/// Describe the size of Android physical screen camera punch hole in `dp`,
class PunchHoleData extends Equatable {
  const PunchHoleData(this.offset, this.radius);
  final Offset offset;
  final double radius;

  @override
  List<Object?> get props => [offset, radius];
}
