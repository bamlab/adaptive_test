import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_packages_theme_example/src/widgets/text.dart';
import 'package:flutter/material.dart';

void main() {
  testAdaptiveWidgets(
    '$AppText render',
    (tester, variant) async {
      await tester.pumpWidget(const MaterialApp(home: AppText('Hello World')));

      expect(find.text('Hello World'), findsOneWidget);
    },
  );
}
