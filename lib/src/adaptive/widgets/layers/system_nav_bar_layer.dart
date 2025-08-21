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
    if (systemNavBarData == null) return child;

    switch (systemNavBarData) {
      case GestureIndicatorSystemNavBarData():
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              child,
              Positioned(
                bottom: systemNavBarData.bottom,
                width: windowConfig.size.width,
                child: Center(
                  child: Container(
                    height: systemNavBarData.size.height,
                    width: systemNavBarData.size.width,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(systemNavBarData.size.height),
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
