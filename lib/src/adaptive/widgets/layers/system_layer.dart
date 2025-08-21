import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:flutter/material.dart';

class SystemLayer extends StatelessWidget {
  const SystemLayer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    final homeIndicator = windowConfig.systemNavBar;
    if (homeIndicator == null) return child;

    switch (homeIndicator) {
      case GestureIndicatorSystemNavBarData():
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              child,
              Positioned(
                bottom: homeIndicator.bottom,
                width: windowConfig.size.width,
                child: Center(
                  child: Container(
                    height: homeIndicator.size.height,
                    width: homeIndicator.size.width,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(homeIndicator.size.height),
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
}
