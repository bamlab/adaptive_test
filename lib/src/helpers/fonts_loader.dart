// ignore_for_file: avoid-dynamic, avoid-accessing-collections-by-constant-index

import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Load fonts and icons to make sure they show up in golden tests.
///
/// To use it efficiently:
/// * Create a flutter_test_config.dart file. See:
/// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
/// * add `await loadFonts();` in the `testExecutable` function.
///
/// /// Load fonts to make sure they show up in golden tests.
///
/// *Note* for this function to work, your package needs to include all fonts
/// it uses az assets.
Future<void> loadFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  final fontManifest = await rootBundle.loadStructuredData<Iterable<dynamic>>(
    'FontManifest.json',
    (string) async => json.decode(string),
  );
  final waitList = <Future<void>>[];
  for (final Map<String, dynamic> font in fontManifest) {
    final fontLoader = FontLoader(font['family']);

    for (final Map<String, dynamic> fontType in font['fonts']) {
      fontLoader.addFont(rootBundle.load(fontType['asset']));
    }
    waitList.add(fontLoader.load());
  }
  await Future.wait(waitList);
}
