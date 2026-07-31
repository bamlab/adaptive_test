import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter_test/flutter_test.dart';

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
  });
}
