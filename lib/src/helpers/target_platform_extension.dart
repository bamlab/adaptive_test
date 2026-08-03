import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

@internal
extension IsRuntimePlatform on TargetPlatform {
  void _logUnusualTargetPlatformWarning() {
    switch (this) {
      case TargetPlatform.linux ||
            TargetPlatform.macOS ||
            TargetPlatform.windows:
        return;

      case TargetPlatform.android ||
            TargetPlatform.iOS ||
            TargetPlatform.fuchsia:
        log('Tests are intended to be runned on linux, macOS or windows'
            ' platform. But you are running them on $name');
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
