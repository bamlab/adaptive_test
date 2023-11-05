import 'package:flutter_test/flutter_test.dart';

import 'package:flutter/material.dart';
import '../window_size.dart';

import 'layers/hardware_layer.dart';
import 'layers/keyboard_layer.dart';
import 'layers/system_layer.dart';

/// Widget wrapper that paint divers window elements over a child.
///
/// See also:
/// * [HardwareLayer]
/// * [SystemLayer]
/// * [KeyboardLayer]
class AdaptiveWrapper extends StatelessWidget {
  const AdaptiveWrapper({
    Key? key,
    required this.child,
    required this.windowConfig,
    required this.tester,
  }) : super(key: key);

  final Widget child;
  final WindowConfigData windowConfig;
  final WidgetTester tester;
  @override
  Widget build(BuildContext context) {
    return WindowConfig(
      windowConfig: windowConfig,
      child: HardwareLayer(
        child: SystemLayer(
          child: KeyboardLayer(
            tester: tester,
            child: child,
          ),
        ),
      ),
    );
  }
}
