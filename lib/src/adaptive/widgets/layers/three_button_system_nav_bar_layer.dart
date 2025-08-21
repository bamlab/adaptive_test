import 'package:adaptive_test/src/adaptive/window_config.dart';
import 'package:adaptive_test/src/adaptive/window_config_data/system_nav_bar_data.dart';
import 'package:flutter/material.dart';

class ThreeButtonSystemNavBarLayer extends StatelessWidget {
  const ThreeButtonSystemNavBarLayer({
    required this.threeButtonNavBar,
    required this.child,
    super.key,
  });

  final ThreeButtonSystemNavBarData threeButtonNavBar;
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
            bottom: threeButtonNavBar.bottomPadding,
            width: windowConfig.size.width,
            child: Container(
              height: threeButtonNavBar.height,
              color: threeButtonNavBar.backgroundColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Icons.arrow_back_ios_rounded,
                  Icons.circle,
                  Icons.square_rounded
                ]
                    .map(
                      (iconData) => Icon(
                        iconData,
                        color: threeButtonNavBar.iconColor,
                        size: threeButtonNavBar.iconSize,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
