import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:simple_app_example/src/app.dart';

void main() {
  group('Excpect golden', () {
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
    testAdaptiveWidgets(
      '$App render with FadeInImage',
      (tester, variant) async {
        await tester.pumpWidget(
          AdaptiveWrapper(
            windowConfig: variant,
            tester: tester,
            child: const App(),
          ),
        );

        await tester.expectGolden<App>(variant, suffix: 'fade_in_image');
      },
    );
    testAdaptiveWidgets(
      '$App render with custom path',
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
          path: 'preview/custom_path_${variant.name}.png',
        );
      },
    );
  });
}
