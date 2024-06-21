import 'package:adaptive_test/adaptive_test.dart';
import 'package:simple_app_example/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testAdaptiveWidgets(
    'Adaptive test without pathBuilder',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: const App(),
        ),
      );

      await tester.expectGolden<App>(variant, suffix: 'simple');

      final textField = find.byType(TextField);

      await tester.tap(textField);
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(variant, suffix: 'simple_with_keyboard');
    },
  );

  testAdaptiveWidgets(
    'Adaptive test with pathBuilder',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: const App(),
        ),
      );

      await tester.expectGolden<App>(
        variant,
        pathBuilder: () {
          return "golden/simple/without_keyboard/${variant.name}.png";
        },
      );

      final textField = find.byType(TextField);

      await tester.tap(textField);
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(
        variant,
        pathBuilder: () {
          return "golden/simple/with_keyboard/${variant.name}.png";
        },
      );
    },
  );
}
