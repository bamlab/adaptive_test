import 'dart:io';

import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;
import 'package:file/file.dart' as f;
import 'package:file/local.dart' as l;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:platform/platform.dart' as p;

/// Load fonts to make sure they show up in golden tests.
///
/// To use it efficiently:
/// * Create a flutter_test_config.dart file. See:
/// https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html
/// * add `await loadFonts();` in the `testExecutable` function.
///
/// *Note* for this function to work, your package needs to include all fonts
/// it uses in a font dir at the root of project.
Future<void> loadFonts([String? package]) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _load(loadFontsFromFontsDir(package));
  await _loadMaterialIconFont();
}

/// Assumes a fonts dir in root of project
@visibleForTesting
Map<String, List<Future<ByteData>>> loadFontsFromFontsDir([String? package]) {
  final fontFamilyToData = <String, List<Future<ByteData>>>{};
  final currentDir = path.dirname(Platform.script.path);
  final fontsDirectory = path.join(
    currentDir,
    package == null ? 'fonts' : '../$package/fonts',
  );
  final prefix = package == null ? '' : 'packages/$package/';
  for (final file in Directory(fontsDirectory).listSync()) {
    if (file is File) {
      final fontFamily =
          prefix + path.basenameWithoutExtension(file.path).split('-').first;
      (fontFamilyToData[fontFamily] ??= [])
          .add(file.readAsBytes().then((bytes) => ByteData.view(bytes.buffer)));
    }
  }
  return fontFamilyToData;
}

Future<void> _load(Map<String, List<Future<ByteData>>> fontFamilyToData) async {
  final waitList = <Future<void>>[];
  for (final entry in fontFamilyToData.entries) {
    final loader = FontLoader(entry.key);
    for (final data in entry.value) {
      loader.addFont(data);
    }
    waitList.add(loader.load());
  }
  await Future.wait(waitList);
}

// Loads the cached material icon font.
// Only necessary for golden tests. Relies on the tool updating cached assets
// before running tests.
Future<void> _loadMaterialIconFont() async {
  const f.FileSystem fs = l.LocalFileSystem();
  const p.Platform platform = p.LocalPlatform();
  final flutterRoot = fs.directory(platform.environment['FLUTTER_ROOT']);

  final iconFont = flutterRoot.childFile(
    fs.path.join(
      'bin',
      'cache',
      'artifacts',
      'material_fonts',
      'MaterialIcons-Regular.otf',
    ),
  );

  final bytes =
      Future<ByteData>.value(iconFont.readAsBytesSync().buffer.asByteData());

  await (FontLoader('MaterialIcons')..addFont(bytes)).load();
}
