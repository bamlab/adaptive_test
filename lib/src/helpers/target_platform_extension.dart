import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

@internal
extension IsRuntimePlatform on TargetPlatform {
  void _logUnusualTargetPlatformWarning() {
    final usualTargetPlatforms = [
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows
    ];

    if (usualTargetPlatforms.contains(this)) {
      return;
    } else {
      log('''Tests are intended to be runned on linux, macOS or windows platform.
      But you are running them on $name''');
    }
  }

  bool get isRuntimePlatform {
    _logUnusualTargetPlatformWarning();

    switch (this) {
      case TargetPlatform.linux:
        return Platform.isLinux;
      case TargetPlatform.macOS:
        return Platform.isMacOS;
      case TargetPlatform.windows:
        return Platform.isWindows;
      case TargetPlatform.android:
        return Platform.isAndroid;
      case TargetPlatform.fuchsia:
        return Platform.isFuchsia;
      case TargetPlatform.iOS:
        return Platform.isIOS;
    }
  }
}
