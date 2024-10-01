// ignore_for_file: avoid-dynamic

import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:package_config/package_config.dart';

/// Loads fonts and icons to ensure they appear in golden tests.
///
/// Usage:
/// 1. Create a flutter_test_config.dart file.
/// 2. Add `await loadFonts();` in the `testExecutable` function.
///
/// Note: Your package must include all used fonts as assets for this to work.
Future<void> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final fontManifest = await _loadFontManifest();
  final packageName = await _getCurrentPackageName();
  await _loadFontsFromManifest(fontManifest, packageName);
}

Future<_FontManifest> _loadFontManifest() async {
  final fontManifest = await rootBundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string),
  );

  return fontManifest.map((font) => _FontData.fromJson(font)).toList();
}

Future<void> _loadFontsFromManifest(
  _FontManifest fontManifest,
  String? packageName,
) async {
  final fontLoaders = fontManifest.expand((font) {
    final regularFontLoader = _createFontLoader(font.family, font.fonts);
    final fontFamilyStartsWithPackages = font.family.startsWith('packages/');

    return [
      regularFontLoader,
      if (!fontFamilyStartsWithPackages && packageName != null)
        _createFontLoader('packages/$packageName/${font.family}', font.fonts),
    ];
  }).toList();

  await Future.wait(fontLoaders.map((loader) => loader.load()));
}

FontLoader _createFontLoader(String fontFamily, List<_FontType> fontTypes) {
  final fontLoader = FontLoader(fontFamily);
  fontTypes.forEach(
    (fontType) => fontLoader.addFont(rootBundle.load(fontType.asset)),
  );

  return fontLoader;
}

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
