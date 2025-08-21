import 'package:adaptive_test/src/adaptive/widgets/layers/hardware_layer.dart';
import 'package:adaptive_test/src/adaptive/widgets/layers/keyboard_layer.dart';
import 'package:adaptive_test/src/adaptive/widgets/layers/system_layer.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/window_config_data.dart';
import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget wrapper that paint divers window elements over a child.
///
/// See also:
/// * [HardwareLayer]
/// * [SystemLayer]
/// * [KeyboardLayer]
class AdaptiveWrapper extends StatelessWidget {
  const AdaptiveWrapper({
    required this.child,
    required this.windowConfig,
    required this.tester,
    super.key,
  });

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
