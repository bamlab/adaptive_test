```dart

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

      await tester.expectGolden<App>(variant);
    },
  );
}
```