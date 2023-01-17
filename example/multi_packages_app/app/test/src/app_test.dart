import 'package:adaptive_test/adaptive_test.dart';
import 'package:multi_packages_example_app/src/app.dart';
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

      await tester.expectGolden<App>(variant, suffix: 'multi_packages');

      final textField = find.byType(TextField);

      await tester.tap(textField);
      await tester.pumpAndSettle();

      await tester.expectGolden<App>(
        variant,
        suffix: 'multi_packages_with_keyboard',
      );
    },
  );
}
