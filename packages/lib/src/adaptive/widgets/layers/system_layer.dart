import 'package:flutter/material.dart';

import '../../window_size.dart';

class SystemLayer extends StatelessWidget {
  const SystemLayer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    final homeIndicator = windowConfig.homeIndicator;
    if (homeIndicator == null) return child;
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
          )
        ],
      ),
    );
  }
}
