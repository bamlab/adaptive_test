import 'package:adaptive_test/src/helpers/platform_fonts.dart';
import 'package:meta/meta.dart';

/// Which font families [loadFonts] provides beyond the ones the font manifest
/// declares, and under which names.
///
/// [platformFamilies] are the families the framework falls back to when a
/// widget does not specify a font, [sdkFamilies] the ones the Flutter SDK ships
/// font files for.
@immutable
@internal
class FontLoadingPolicy {
  const FontLoadingPolicy({
    required this.platformFamilies,
    required this.sdkFamilies,
  });

  /// Provides the platform default families, gathered from the SDK.
  factory FontLoadingPolicy.platformAware() => FontLoadingPolicy(
        platformFamilies: platformDefaultFontFamilies(),
        sdkFamilies: sdkFontFamilies(),
      );

  /// Registers nothing but what the font manifest declares.
  const FontLoadingPolicy.manifestOnly()
      : platformFamilies = const {},
        sdkFamilies = const {};

  final Set<String> platformFamilies;
  final Set<String> sdkFamilies;

  /// Whether a font bundled by a dependency, exposed by the manifest as
  /// `packages/my_theme/Roboto`, is also registered under its bare [family]
  /// name — the name a `TextStyle` or a `ThemeData` asks for.
  ///
  /// It is, unless it would shadow a platform default the SDK ships a font for.
  /// A dependency usually bundles a single weight of such a family while the
  /// SDK ships all of them, and on a device that bundled font would not shadow
  /// the platform one either: it is only reachable through its `packages/`
  /// name.
  bool registersBareFamilyName(String family) =>
      !platformFamilies.contains(family) || !sdkFamilies.contains(family);

  /// The families that must be provided on top of the manifest, so that text
  /// laid out with a platform default does not render as placeholder blocks.
  Set<String> get familiesToProvide => platformFamilies;
}
