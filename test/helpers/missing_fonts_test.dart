import 'package:adaptive_test/adaptive_test.dart';
import 'package:adaptive_test/src/helpers/missing_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _registeredFamily = 'ARegisteredFamily';
const _unregisteredFamily = 'AnUnregisteredFamily';

/// Registers [family] with no asset behind it and returns its name: these
/// tests only care about whether a family is known, not about its glyphs.
Future<String> _registerEmptyFamily(String family) async {
  await FontLoader(family).load();

  return family;
}

void main() {
  late Set<String> loadedFamilies;

  setUpAll(() async {
    // The app fonts and the platform defaults are loaded, so that only the
    // families these tests introduce are reported as missing.
    loadedFamilies = {
      ...await loadFonts(),
      await _registerEmptyFamily(_registeredFamily),
    };
  });

  group('findUnregisteredFontFamilies', () {
    Future<Set<String>> familiesOf(WidgetTester tester, Widget child) async {
      // Wrapped in a Scaffold: a bare MaterialApp home inherits the debug
      // error text style, which brings its own font family along. The default
      // text style is pinned to a registered family so that what the ambient
      // theme happens to ask for on this host does not leak into the result.
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: DefaultTextStyle(
              style: const TextStyle(fontFamily: _registeredFamily),
              child: child,
            ),
          ),
        ),
      );

      // ignore: avoid-non-null-assertion, the tree has just been pumped
      return findUnregisteredFontFamilies(
        tester.element(find.byWidget(child)).renderObject!,
        loadedFamilies: loadedFamilies,
      );
    }

    testWidgets('reports a family no font is registered for', (tester) async {
      final families = await familiesOf(
        tester,
        const Text(
          'Hello',
          style: TextStyle(fontFamily: _unregisteredFamily),
        ),
      );

      expect(families, {_unregisteredFamily});
    });

    testWidgets('ignores a registered family', (tester) async {
      final families = await familiesOf(
        tester,
        const Text('Hello', style: TextStyle(fontFamily: _registeredFamily)),
      );

      expect(families, isEmpty);
    });

    testWidgets('ignores a family with a registered fallback', (tester) async {
      final families = await familiesOf(
        tester,
        const Text(
          'Hello',
          style: TextStyle(
            fontFamily: _unregisteredFamily,
            fontFamilyFallback: [_registeredFamily],
          ),
        ),
      );

      expect(families, isEmpty);
    });

    testWidgets('reports the families of nested spans', (tester) async {
      final families = await familiesOf(
        tester,
        const Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Hello',
                style: TextStyle(fontFamily: _registeredFamily),
              ),
              TextSpan(
                text: 'World',
                style: TextStyle(fontFamily: _unregisteredFamily),
              ),
            ],
          ),
        ),
      );

      expect(families, {_unregisteredFamily});
    });

    testWidgets('reports the family of an editable text', (tester) async {
      final families = await familiesOf(
        tester,
        TextField(
          controller: TextEditingController(text: 'Hello'),
          style: const TextStyle(fontFamily: _unregisteredFamily),
        ),
      );

      expect(families, contains(_unregisteredFamily));
    });
  });

  group('reportUnregisteredFontFamilies', () {
    List<String> capturePrints(void Function() body) {
      final logs = <String>[];
      final previous = debugPrint;
      debugPrint = (message, {wrapWidth}) => logs.add(message ?? '');
      try {
        body();
      } finally {
        debugPrint = previous;
      }

      return logs;
    }

    test('warns about the families it is given', () {
      late Set<String> warnedFamilies;
      final logs = capturePrints(() {
        warnedFamilies = reportUnregisteredFontFamilies(
          {_unregisteredFamily},
          MissingFontsBehavior.warn,
        );
      });

      expect(warnedFamilies, {_unregisteredFamily});
      expect(logs, hasLength(1));
      expect(logs.single, contains(_unregisteredFamily));
    });

    test('stays silent about a family already warned about', () {
      late Set<String> warnedFamilies;
      final logs = capturePrints(() {
        warnedFamilies = reportUnregisteredFontFamilies(
          {_unregisteredFamily},
          MissingFontsBehavior.warn,
          alreadyWarned: {_unregisteredFamily},
        );
      });

      expect(warnedFamilies, isEmpty);
      expect(logs, isEmpty);
    });

    test('stays silent when there is nothing to report', () {
      final logs = capturePrints(
        () => reportUnregisteredFontFamilies(
          const {},
          MissingFontsBehavior.warn,
        ),
      );

      expect(logs, isEmpty);
    });

    test('stays silent when ignoring', () {
      final logs = capturePrints(
        () => reportUnregisteredFontFamilies(
          {_unregisteredFamily},
          MissingFontsBehavior.ignore,
        ),
      );

      expect(logs, isEmpty);
    });

    test('fails the test when configured to', () {
      expect(
        () => reportUnregisteredFontFamilies(
          {_unregisteredFamily},
          MissingFontsBehavior.fail,
        ),
        throwsA(
          isA<TestFailure>().having(
            (failure) => failure.message,
            'message',
            contains(_unregisteredFamily),
          ),
        ),
      );
    });
  });
}
