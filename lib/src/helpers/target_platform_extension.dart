import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@internal
extension IsRuntimePlatform on TargetPlatform {
  bool get isRuntimePlatform {
    switch (this) {
      case TargetPlatform.android:
        return Platform.isAndroid;
      case TargetPlatform.fuchsia:
        return Platform.isFuchsia;
      case TargetPlatform.iOS:
        return Platform.isIOS;
      case TargetPlatform.linux:
        return Platform.isLinux;
      case TargetPlatform.macOS:
        return Platform.isMacOS;
      case TargetPlatform.windows:
        return Platform.isWindows;
    }
  }
}
