import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:flutter/material.dart';

class GestureIndicatorSystemNavBarLayer extends StatelessWidget {
  const GestureIndicatorSystemNavBarLayer({
    required this.gestureIndicator,
    required this.child,
    super.key,
  });

  final GestureIndicatorSystemNavBarData gestureIndicator;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          Positioned(
            bottom: gestureIndicator.bottom,
            width: windowConfig.size.width,
            child: Center(
              child: Container(
                height: gestureIndicator.size.height,
                width: gestureIndicator.size.width,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(gestureIndicator.size.height),
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
