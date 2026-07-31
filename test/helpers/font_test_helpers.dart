import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Whether text laid out with [fontFamily] is rendered with a real font.
///
/// The placeholder font used by `flutter_test` when a family is unknown gives
/// every glyph the same advance, so a narrow and a wide string of the same
/// length measure exactly the same. Any real proportional font measures them
/// differently, which makes this a reliable way to assert a font was loaded
/// without comparing golden files.
bool rendersWithARealFont(String fontFamily) {
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

extension FontFilesToAssets on Iterable<File> {
  /// The font files as the byte data a font loader expects.
  Iterable<Future<ByteData>> toByteData() => map(
        (file) async => ByteData.view((await file.readAsBytes()).buffer),
      );
}
