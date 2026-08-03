import 'package:adaptive_test/adaptive_test.dart';
import 'package:adaptive_test/src/helpers/platform_fonts.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

import 'font_test_helpers.dart';

void main() {
  late Set<String> loadedFamilies;

  setUpAll(() async => loadedFamilies = await loadFonts());

  group('loadFonts', () {
    test('registers the families declared in the font manifest', () {
      // Bundled by this package through `uses-material-design: true`.
      expect(loadedFamilies, contains('MaterialIcons'));
    });

    test('registers a dependency font under its manifest name', () {
      // Bundled by the cupertino_icons dependency.
      expect(
        loadedFamilies,
        contains('packages/cupertino_icons/CupertinoIcons'),
      );
    });

    test('registers a dependency font under its bare family name too', () {
      // A widget styled with
      // `TextStyle(fontFamily: 'CupertinoIcons', package: 'cupertino_icons')`
      // asks for the bare name, not the manifest one.
      expect(loadedFamilies, contains('CupertinoIcons'));
    });

    test('registers every font family the framework falls back to', () {
      expect(
        platformDefaultFontFamilies().difference(loadedFamilies),
        isEmpty,
      );
    });

    test('makes the platform default families render real glyphs', () {
      final blockRendering = platformDefaultFontFamilies().whereNot(
        rendersWithARealFont,
      );

      expect(
        blockRendering,
        isEmpty,
        reason: 'those families render with the placeholder test font',
      );
    });

    test('leaves unknown families to the placeholder font', () {
      expect(rendersWithARealFont('NotARegisteredFontFamily'), isFalse);
    });
  });
}
