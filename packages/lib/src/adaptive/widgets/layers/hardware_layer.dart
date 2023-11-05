import 'package:flutter/material.dart';

import '../../window_size.dart';

/// Widget wrapper that paint hardware elements over a child.
///
/// Elements are:
/// * Device border radius.
/// * Device notch.
/// * Device punch holde.
class HardwareLayer extends StatelessWidget {
  const HardwareLayer({
    Key? key,
    required this.child,
  }) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    return ClipRRect(
      borderRadius: windowConfig.borderRadius,
      clipBehavior: Clip.antiAlias,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Stack(
          children: [
            child,
            const _Notch(),
            const _PunchHole(),
          ],
        ),
      ),
    );
  }
}

class _Notch extends StatelessWidget {
  const _Notch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    final notchSize = windowConfig.notchSize;

    if (notchSize == null) return const SizedBox();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _NotchCorner(
          clipper: _NotchLeftClipper(),
        ),
        Container(
          height: notchSize.height,
          width: notchSize.width,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(notchSize.height * 0.625),
              bottomRight: Radius.circular(notchSize.height * 0.625),
            ),
          ),
        ),
        _NotchCorner(
          clipper: _NotchRightClipper(),
        ),
      ],
    );
  }
}

class _PunchHole extends StatelessWidget {
  const _PunchHole({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    final punchHole = windowConfig.punchHole;
    if (punchHole == null) return const SizedBox();
    return Positioned(
      top: punchHole.offset.dy,
      left: punchHole.offset.dx,
      child: Container(
        height: punchHole.radius,
        width: punchHole.radius,
        decoration: const BoxDecoration(
          color: Colors.black,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _NotchCorner extends StatelessWidget {
  const _NotchCorner({
    Key? key,
    required this.clipper,
  }) : super(key: key);

  final CustomClipper<Path> clipper;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: clipper,
      child: Container(
        height: 3,
        width: 3,
        color: Colors.black,
      ),
    );
  }
}

class _NotchLeftClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..relativeArcToPoint(
        Offset(-size.width, -size.height),
        clockwise: false,
        radius: Radius.circular(size.width),
      );
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}

class _NotchRightClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(size.width, 0)
      ..relativeArcToPoint(
        Offset(-size.width, size.height),
        clockwise: false,
        radius: Radius.circular(size.width),
      )
      ..lineTo(0, -size.height);
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return oldClipper != this;
  }
}
