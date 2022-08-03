import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Dart extension to add an await images function to a [WidgetTester] object,
/// e.g. [awaitImages];
extension AwaitImages on WidgetTester {
  /// Pauses test until images are ready to be rendered.
  Future<void> awaitImages() async {
    await runAsync(() async {
      for (final element in find.byType(Image).evaluate()) {
        final widget = element.widget as Image;
        final image = widget.image;
        await precacheImage(image, element);
        await pumpAndSettle();
      }

      for (final element in find.byType(DecoratedBox).evaluate()) {
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
    });
  }
}
