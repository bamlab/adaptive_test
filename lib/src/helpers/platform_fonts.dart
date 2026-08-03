import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_test/src/helpers/font_registration.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

/// The font families the framework itself falls back to when a widget does not
/// specify one, gathered from the SDK rather than hardcoded so that the list
/// keeps up with Flutter (`Roboto`, `CupertinoSystemText`, `Segoe UI`, ...).
///
/// None of those families are declared in a `pubspec.yaml`: they are provided
/// by the host OS or bundled with the engine, so [loadFonts] cannot find them
/// in the font manifest.
@internal
Set<String> platformDefaultFontFamilies() {
  const cupertinoTextTheme = CupertinoTextThemeData();

  return {
    ...TargetPlatform.values
        .map(
          (targetPlatform) => Typography.material2021(platform: targetPlatform),
        )
        .expand(_textThemesOf)
        .expand(_representativeStylesOf)
        .expand(_familiesOf),
    ...[
      cupertinoTextTheme.textStyle,
      cupertinoTextTheme.navTitleTextStyle,
      cupertinoTextTheme.navLargeTitleTextStyle,
      cupertinoTextTheme.actionTextStyle,
      cupertinoTextTheme.tabLabelTextStyle,
      cupertinoTextTheme.pickerTextStyle,
    ].expand(_familiesOf),
  };
}

Iterable<TextTheme> _textThemesOf(Typography typography) => [
      typography.black,
      typography.white,
      typography.englishLike,
      typography.dense,
      typography.tall,
    ];

/// The families do not vary with the size within a text theme, so a few styles
/// are enough to collect them all.
Iterable<TextStyle?> _representativeStylesOf(TextTheme textTheme) => [
      textTheme.displayLarge,
      textTheme.headlineMedium,
      textTheme.titleMedium,
      textTheme.bodyMedium,
      textTheme.labelLarge,
    ];

Iterable<String> _familiesOf(TextStyle? style) => [
      if (style?.fontFamily case final family?) family,
      ...?style?.fontFamilyFallback,
    ];

/// Locates the fonts shipped with the Flutter SDK
/// (`$FLUTTER_ROOT/bin/cache/artifacts/material_fonts`).
///
/// `FLUTTER_ROOT` is exported by `flutter test`, but the directory is also
/// resolved by walking up from the test executable, which lives inside the
/// same `bin/cache` tree, so this keeps working in environments where the
/// variable is not set.
Directory? _findMaterialFontsDirectory() {
  const dirName = 'material_fonts';
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];

  final candidatePaths = [
    if (flutterRoot != null)
      path.join(flutterRoot, 'bin', 'cache', 'artifacts', dirName),
    // e.g. $FLUTTER_ROOT/bin/cache/artifacts/engine/darwin-x64/flutter_tester
    ..._ancestorsOf(File(Platform.resolvedExecutable).parent.path)
        .map((ancestor) => path.join(ancestor, dirName)),
  ];

  return candidatePaths
      .map(Directory.new)
      .firstWhereOrNull((directory) => directory.existsSync());
}

/// The given directory and all its parents, closest first.
Iterable<String> _ancestorsOf(String directoryPath) {
  final segments = path.split(directoryPath);

  return List.generate(
    segments.length,
    (index) => path.joinAll(segments.take(segments.length - index)),
  );
}

/// The font files the Flutter SDK ships, grouped by the family they belong to.
///
/// Empty when the SDK font cache cannot be located.
@visibleForTesting
Map<String, List<File>> sdkFontFilesByFamily() {
  const fontExtensions = ['.ttf', '.otf'];
  final fontsDirectory = _findMaterialFontsDirectory();
  if (fontsDirectory == null || !fontsDirectory.existsSync()) return const {};

  final fontFiles = fontsDirectory
      .listSync()
      .whereType<File>()
      .where((file) => fontExtensions.contains(path.extension(file.path)))
      // A directory listing comes back in file system order, which differs
      // between APFS, ext4 and NTFS, and the fonts must be registered in the
      // same order on every machine for the goldens to match.
      .sortedBy((file) => file.path);

  return Map.fromEntries(
    fontFiles.groupListsBy(_familyNameOf).entries.expand(
          (entry) => [
            if (entry.key case final family?) MapEntry(family, entry.value),
          ],
        ),
  );
}

/// The family a font file belongs to, e.g. `Roboto-BoldItalic.ttf` belongs to
/// `Roboto`.
///
/// Null for a file name that carries no family at all, which the fonts shipped
/// by the SDK always do: such a file is left out rather than grouped under a
/// made up name.
String? _familyNameOf(File file) =>
    path.basenameWithoutExtension(file.path).split('-').firstOrNull;

/// The font families the Flutter SDK ships font files for.
///
/// Empty when the SDK font cache cannot be located.
@internal
Set<String> sdkFontFamilies() => sdkFontFilesByFamily().keys.toSet();

/// Registers the [familiesToProvide] that [alreadyLoaded] does not cover, so
/// that text laid out with a platform default renders real glyphs instead of
/// placeholder blocks, and returns the families it registered.
///
/// Families that the SDK actually ships (`Roboto`) are loaded from their own
/// files. The remaining ones are provided by the host OS and cannot be loaded
/// at all — Apple's `CupertinoSystemText` for instance — so they are aliased
/// to the face the SDK ships. Glyphs then differ from a real device, but the
/// goldens stay readable and stable.
@internal
Future<Set<String>> loadPlatformFallbackFonts({
  required Set<String> familiesToProvide,
  required Set<String> alreadyLoaded,
}) async {
  final missingFamilies = familiesToProvide.difference(alreadyLoaded);
  if (missingFamilies.isEmpty) return const {};

  final availableFamilies = sdkFontFilesByFamily();
  final frameworkFallbackFamily = _frameworkFallbackFamily(
    availableFamilies.keys,
    familiesToProvide,
  );
  if (frameworkFallbackFamily == null) return const {};

  // Only the files that are about to be registered are read, and each one only
  // once: the same bytes are reused by every family aliased to them.
  final ownAssets = Map<String, List<ByteData>>.fromEntries(
    availableFamilies.entries
        .where((entry) => missingFamilies.contains(entry.key))
        .map((entry) => MapEntry(entry.key, _readAll(entry.value))),
  );
  final frameworkFallbackAssets = ownAssets[frameworkFallbackFamily] ??
      _readAll(availableFamilies[frameworkFallbackFamily] ?? const []);

  final registeredFamilies = await Future.wait(
    missingFamilies.map(
      (family) => registerFontFamily(
        family,
        (ownAssets[family] ?? frameworkFallbackAssets)
            .map(Future<ByteData>.value),
      ),
    ),
  );

  return registeredFamilies.toSet();
}

/// The family the framework falls back to that the SDK ships a font for, used
/// to stand in for the families only the host OS can provide.
///
/// Derived from what the framework defaults to, so no typeface name has to be
/// hardcoded here.
String? _frameworkFallbackFamily(
  Iterable<String> availableFamilies,
  Set<String> platformFamilies,
) =>
    availableFamilies
        .toSet()
        .intersection(platformFamilies)
        .sorted((a, b) => a.compareTo(b))
        .firstOrNull;

List<ByteData> _readAll(Iterable<File> files) =>
    files.map((file) => ByteData.view(file.readAsBytesSync().buffer)).toList();
