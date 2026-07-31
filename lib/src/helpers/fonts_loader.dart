// ignore_for_file: avoid-dynamic

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_test/src/helpers/font_registration.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_config/package_config.dart';

/// Loads the fonts and icons the goldens need, and returns the font families
/// that were registered.
///
/// Usage:
/// 1. Create a flutter_test_config.dart file.
/// 2. Add `await loadFonts();` in the `testExecutable` function.
///
/// Note: Your package must include all used fonts as assets for this to work.
Future<Set<String>> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  return _loadFontsFromManifest(
    await _loadFontManifest(),
    packageName: await _getCurrentPackageName(),
  );
}

Future<_FontManifest> _loadFontManifest() async {
  final fontManifest = await rootBundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string),
  );

  return fontManifest.map((font) => _FontData.fromJson(font)).toList();
}

Future<Set<String>> _loadFontsFromManifest(
  _FontManifest fontManifest, {
  required String? packageName,
}) async {
  final loadings = fontManifest.expand((font) {
    final fontFamilyStartsWithPackages = font.family.startsWith('packages/');
    // A font bundled by a dependency shows up as `packages/<pkg>/<family>` in
    // the manifest, but a widget styled with
    // `TextStyle(fontFamily: 'Roboto', package: 'my_theme')` — or a theme
    // defaulting to that family — asks for the bare name.
    final bareFamily =
        fontFamilyStartsWithPackages ? _bareFamilyName(font.family) : null;

    return [
      _loadFontFamily(font.family, font.fonts),
      if (!fontFamilyStartsWithPackages && packageName != null)
        _loadFontFamily('packages/$packageName/${font.family}', font.fonts),
      if (bareFamily != null) _loadFontFamily(bareFamily, font.fonts),
    ];
  }).toList();

  return (await Future.wait(loadings)).toSet();
}

Future<String> _loadFontFamily(String fontFamily, List<_FontType> fontTypes) {
  return registerFontFamily(
    fontFamily,
    fontTypes.map((fontType) => rootBundle.load(fontType.asset)),
  );
}

/// `packages/my_theme/Roboto` -> `Roboto`.
String _bareFamilyName(String manifestFamily) =>
    manifestFamily.split('/').skip(2).join('/');

Future<String?> _getCurrentPackageName() async {
  final current = Directory.current;
  final packageConfig = await findPackageConfig(current);

  return packageConfig?.packageOf(current.uri)?.name;
}

typedef _FontManifest = List<_FontData>;

class _FontData {
  const _FontData({required this.family, required this.fonts});

  factory _FontData.fromJson(Map<String, dynamic> json) {
    return _FontData(
      family: json['family'] as String,
      fonts: (json['fonts'] as List)
          .map((font) => _FontType.fromJson(font))
          .toList(),
    );
  }
  final String family;
  final List<_FontType> fonts;
}

class _FontType {
  const _FontType({required this.asset});

  factory _FontType.fromJson(Map<String, dynamic> json) {
    return _FontType(asset: json['asset'] as String);
  }
  final String asset;
}
