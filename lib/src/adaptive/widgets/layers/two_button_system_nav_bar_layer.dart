import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:flutter/material.dart';

class TwoButtonSystemNavBarLayer extends StatelessWidget {
  const TwoButtonSystemNavBarLayer({
    required this.twoButtonNavBar,
    required this.child,
    super.key,
  });

  final TwoButtonSystemNavBarData twoButtonNavBar;
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
            bottom: twoButtonNavBar.bottomPadding,
            width: windowConfig.size.width,
            child: Container(
              height: twoButtonNavBar.height,
              color: twoButtonNavBar.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Back button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Icon(
                      Icons.arrow_back,
                      color: twoButtonNavBar.iconColor,
                    ),
                  ),
                  // Home pill (centered visually)
                  Center(
                    child: Container(
                      height: twoButtonNavBar.homeHeight,
                      width: twoButtonNavBar.homeWidth,
                      decoration: BoxDecoration(
                        color: twoButtonNavBar.iconColor,
                        borderRadius:
                            BorderRadius.circular(twoButtonNavBar.homeHeight),
                      ),
                    ),
                  ),

                  // Right side is empty (no tasks button)
                  const SizedBox(width: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
