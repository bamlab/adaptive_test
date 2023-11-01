import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dart extension to add an await images function to a [WidgetTester] object,
/// e.g. [awaitImages];
extension AwaitImages on WidgetTester {
  /// Pauses test until images are ready to be rendered.
  Future<void> awaitImages() async {
    await runAsync(() async {
      bool shouldReCall = false;
      shouldReCall = await _awaitImages();
      while (shouldReCall) {
        shouldReCall = await _awaitImages();
      }
      for (final element in find.byType(DecoratedBox).evaluate().toList()) {
        final widget = element.widget as DecoratedBox;
        final decoration = widget.decoration;
        if (decoration is BoxDecoration) {
          final image = decoration.image?.image;
          if (image != null) {
            await precacheImage(image, element);
            await pumpAndSettle();
          }
        }
      }
      if (shouldReCall) await awaitImages();
    });
  }

  Future<bool> _awaitImages() async {
    bool allIsLoaded = false;
    for (final element in find.byType(Image).evaluate().toList()) {
      if (element.mounted == false) {
        allIsLoaded = true;
        continue; // ignore: avoid_slow_async_io
      }
      final widget = element.widget as Image;
      final image = widget.image;
      await precacheImage(image, element);
      await pumpAndSettle(const Duration(seconds: 1));
    }
    return allIsLoaded;
  }
}
