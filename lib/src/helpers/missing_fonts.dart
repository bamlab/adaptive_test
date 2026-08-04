import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// What to do when a widget tree asks for a font family that no font has been
/// registered for. Such text renders as placeholder blocks in goldens, which is
/// easy to miss when reviewing them.
enum MissingFontsBehavior {
  /// Do not check for missing font families.
  ignore,

  /// Print a warning listing the missing families. This is the default.
  warn,

  /// Fail the test. Recommended on CI once the suite is clean.
  fail,
}

/// The font families the rendered text asks for while [loadedFamilies], as
/// returned by [loadFonts], does not cover them.
///
/// A family is only reported when none of the fallbacks of the style is covered
/// either, since the engine would then have a real font to use.
Set<String> findUnregisteredFontFamilies(
  RenderObject root, {
  required Set<String> loadedFamilies,
}) {
  final unregisteredFamilies = <String>{};

  void visitStyle(TextStyle? style) {
    final family = style?.fontFamily;
    if (style == null || family == null) return;

    final candidates = [family, ...?style.fontFamilyFallback];
    if (candidates.any(loadedFamilies.contains)) return;

    unregisteredFamilies.add(family);
  }

  void visitSpan(InlineSpan span) {
    if (span is TextSpan) visitStyle(span.style);
    span.visitChildren((child) {
      if (child != span) visitSpan(child);

      return true;
    });
  }

  void visitRenderObject(RenderObject renderObject) {
    switch (renderObject) {
      case final RenderParagraph paragraph:
        visitSpan(paragraph.text);
      case final RenderEditable editable:
        if (editable.text case final text?) visitSpan(text);
      default:
        break;
    }
    renderObject.visitChildren(visitRenderObject);
  }

  visitRenderObject(root);

  return unregisteredFamilies;
}

/// Reports the [families] no font is registered for, according to [behavior],
/// and returns the ones it warned about.
///
/// The families of [alreadyWarned] are skipped, so that the output stays
/// readable when many goldens share the same gap.
Set<String> reportUnregisteredFontFamilies(
  Set<String> families,
  MissingFontsBehavior behavior, {
  Set<String> alreadyWarned = const {},
}) {
  if (behavior == MissingFontsBehavior.ignore || families.isEmpty) {
    return const {};
  }

  if (behavior == MissingFontsBehavior.fail) {
    throw TestFailure(_message(families));
  }

  final familiesToWarnAbout = families.difference(alreadyWarned);
  if (familiesToWarnAbout.isEmpty) return const {};

  debugPrint(_message(familiesToWarnAbout));

  return familiesToWarnAbout;
}

String _message(Set<String> families) {
  final sortedFamilies = families.toList()..sort();

  return '''
adaptive_test: no font is registered for ${sortedFamilies.map((family) => "'$family'").join(', ')}.
The text using ${sortedFamilies.length > 1 ? 'those families' : 'that family'} renders as placeholder blocks in the golden.
Declare the font in your pubspec.yaml so that loadFonts() picks it up, or, if it
is provided by the host OS, register a stand-in with FontLoader before the test.''';
}
