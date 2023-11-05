import 'package:adaptive_test_extended/adaptive_test_extended.dart';
import 'package:multi_packages_example_app/src/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helper.dart';

void main() {
  testAdaptiveThemedWidgets(
    '$App render themed',
    (tester, variant) async {
      final themeData = variant.themeMode == ThemeMode.dark
          ? ThemeData(
              fontFamily: 'roboto',
              brightness: Brightness.dark,
              primarySwatch: generateMaterialColor(const Color(0xFF002544)),
            )
          : ThemeData(
              primarySwatch: Colors.blue,
              brightness: Brightness.light,
              fontFamily: 'roboto',
            );
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: App(themeData: themeData),
        ),
      );

      await tester.expectGolden<App>(variant, suffix: 'multi_packages');
    },
  );

  testAdaptiveWidgets(
    '$App render unThemed',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: const App(),
        ),
      );

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
