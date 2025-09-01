import 'package:adaptive_test/src/adaptive/widgets/layers/gesture_indicator_system_nav_bar_layer.dart';
import 'package:adaptive_test/src/adaptive/widgets/layers/three_button_system_nav_bar_layer.dart';
import 'package:adaptive_test/src/adaptive/widgets/layers/two_button_system_nav_bar_layer.dart';
import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:flutter/material.dart';

class SystemNavBarLayer extends StatelessWidget {
  const SystemNavBarLayer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    final systemNavBarData = windowConfig.systemNavBar;

    switch (systemNavBarData) {
      case GestureIndicatorSystemNavBarData():
        return GestureIndicatorSystemNavBarLayer(
          gestureIndicator: systemNavBarData,
          child: child,
        );

      case ThreeButtonSystemNavBarData():
        return ThreeButtonSystemNavBarLayer(
          threeButtonNavBar: systemNavBarData,
          child: child,
        );

      case TwoButtonSystemNavBarData():
        return TwoButtonSystemNavBarLayer(
          twoButtonNavBar: systemNavBarData,
          child: child,
        );

      case null:
        return child;
    }
  }
}
