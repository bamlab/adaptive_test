import 'package:adaptive_test/adaptive_test.dart';
import 'package:adaptive_test/src/configuration.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Set<String> loadedFamilies;

  setUpAll(() async => loadedFamilies = await loadFonts());

  group('loadFonts', () {
    test('returns the families it registered', () {
      expect(loadedFamilies, isNotEmpty);
    });

    test('records the loaded families in the configuration', () {
      expect(
        FontLoadingRegistry.loadedFontFamilies,
        containsAll(loadedFamilies),
      );
    });
  });
}
