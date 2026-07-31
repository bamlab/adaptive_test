import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Whether text laid out with [fontFamily] is rendered with a real font.
///
/// The placeholder font `flutter_test` uses for unknown families gives every
/// glyph the same advance, so a narrow and a wide string of the same length
/// measure the same. Any real proportional font measures them differently.
bool _rendersWithARealFont(String fontFamily) {
  double widthOf(String text) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontFamily: fontFamily, fontSize: 40),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final width = painter.width;
    painter.dispose();

    return width;
  }

  return widthOf('iiii') != widthOf('WWWW');
}

void main() {
  group('loadFonts in an app whose fonts live in a dependency', () {
    test('renders a font bundled by a dependency under its bare name', () {
      // ThemeSans is bundled by the theme package this app depends on, so the
      // manifest only exposes it as
      // `packages/multi_packages_example_theme/ThemeSans` — but a widget or a
      // theme defaulting to that family asks for the bare name.
      expect(_rendersWithARealFont('ThemeSans'), isTrue);
    });

    test('keeps the family under its manifest name as well', () {
      expect(
        _rendersWithARealFont(
          'packages/multi_packages_example_theme/ThemeSans',
        ),
        isTrue,
      );
    });

  });
}
