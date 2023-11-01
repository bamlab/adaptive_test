import 'package:adaptive_test_extended/adaptive_test_extended.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:multi_packages_example_theme/src/widgets/text.dart';
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
