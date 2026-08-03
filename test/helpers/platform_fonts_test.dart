import 'package:adaptive_test/src/helpers/platform_fonts.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('platformDefaultFontFamilies', () {
    test('collects the families of every target platform typography', () {
      final materialFamilies = TargetPlatform.values
          .map(
            (targetPlatform) => Typography.material2021(
              platform: targetPlatform,
            ).black.bodyMedium?.fontFamily,
          )
          .nonNulls
          .toSet();

      expect(materialFamilies, isNotEmpty);
      expect(platformDefaultFontFamilies(), containsAll(materialFamilies));
    });

    test('collects the Cupertino default family', () {
      const cupertinoTextTheme = CupertinoTextThemeData();
      final cupertinoFamily = cupertinoTextTheme.textStyle.fontFamily;

      expect(cupertinoFamily, isNotNull);
      expect(platformDefaultFontFamilies(), contains(cupertinoFamily));
    });

    test('collects the fallbacks declared by the styles', () {
      final fallbacks = TargetPlatform.values
          .expand(
            (targetPlatform) =>
                Typography.material2021(platform: targetPlatform)
                    .black
                    .bodyMedium
                    ?.fontFamilyFallback ??
                const <String>[],
          )
          .toSet();

      expect(platformDefaultFontFamilies(), containsAll(fallbacks));
    });
  });

  group('determinism across machines', () {
    test('registers the SDK font files in a file system agnostic order', () {
      // A directory listing comes back in file system order, which differs
      // between APFS, ext4 and NTFS.
      final filesByFamily = sdkFontFilesByFamily();

      final unsortedFamilies = filesByFamily.entries.where((entry) {
        final paths = entry.value.map((file) => file.path).toList();

        return !paths.equals(paths.sorted((a, b) => a.compareTo(b)));
      }).map((entry) => entry.key);

      expect(filesByFamily, isNotEmpty);
      expect(unsortedFamilies, isEmpty);
    });

    test('does not depend on the host platform', () {
      // The families are enumerated for every TargetPlatform, not for the one
      // the test happens to run on.
      final families = platformDefaultFontFamilies();

      final perHostPlatform = TargetPlatform.values.map((targetPlatform) {
        debugDefaultTargetPlatformOverride = targetPlatform;

        return platformDefaultFontFamilies();
      }).toList();
      debugDefaultTargetPlatformOverride = null;

      expect(
        perHostPlatform.where((collected) => !setEquals(collected, families)),
        isEmpty,
      );
    });
  });

  group('sdkFontFamilies', () {
    test('lists the families the SDK ships', () {
      // Also covers locating the SDK font cache, which callers cannot do
      // themselves anymore.
      final families = sdkFontFamilies();

      expect(families, isNotEmpty);
      expect(
        families.intersection(platformDefaultFontFamilies()),
        isNotEmpty,
        reason: 'the SDK ships at least one of the platform default families',
      );
    });
  });

  group('loadPlatformFallbackFonts', () {
    test('registers every family it is asked to provide', () async {
      final registeredFamilies = await loadPlatformFallbackFonts(
        familiesToProvide: platformDefaultFontFamilies(),
        alreadyLoaded: const {},
      );

      expect(registeredFamilies, containsAll(platformDefaultFontFamilies()));
    });

    test('aliases the families the SDK does not ship any file for', () async {
      final osProvidedFamilies =
          platformDefaultFontFamilies().difference(sdkFontFamilies());

      final registeredFamilies = await loadPlatformFallbackFonts(
        familiesToProvide: platformDefaultFontFamilies(),
        alreadyLoaded: const {},
      );

      // e.g. Apple's CupertinoSystemText, which no font file can provide.
      expect(osProvidedFamilies, isNotEmpty);
      expect(registeredFamilies, containsAll(osProvidedFamilies));
    });

    test('skips the families already loaded', () async {
      final registeredFamilies = await loadPlatformFallbackFonts(
        familiesToProvide: platformDefaultFontFamilies(),
        alreadyLoaded: platformDefaultFontFamilies(),
      );

      expect(registeredFamilies, isEmpty);
    });

    test('registers nothing when there is nothing to provide', () async {
      final registeredFamilies = await loadPlatformFallbackFonts(
        familiesToProvide: const {},
        alreadyLoaded: const {},
      );

      expect(registeredFamilies, isEmpty);
    });
  });
}
