import 'package:adaptive_test_extended/adaptive_test_extended.dart';
import 'package:simple_app_example/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testAdaptiveWidgets(
    '$App render',
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

      await tester.expectGolden<App>(
        variant,
        suffix: 'simple_with_keyboard',
      );
    },
  );
}
