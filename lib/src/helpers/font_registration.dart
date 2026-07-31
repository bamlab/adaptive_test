import 'package:flutter/services.dart';

/// Registers [assets] under [family] and returns that family name, so that
/// callers can collect what they loaded without going through shared state.
Future<String> registerFontFamily(
  String family,
  Iterable<Future<ByteData>> assets,
) async {
  final loader = FontLoader(family);
  assets.forEach(loader.addFont);
  await loader.load();

  return family;
}
