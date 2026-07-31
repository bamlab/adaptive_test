import 'package:adaptive_test/src/helpers/font_loading_policy.dart';
import 'package:adaptive_test/src/helpers/platform_fonts.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('registersBareFamilyName', () {
    const policy = FontLoadingPolicy(
      platformFamilies: {'Roboto', 'CupertinoSystemText'},
      sdkFamilies: {'Roboto'},
    );

    test('registers a family that is not a platform default', () {
      expect(policy.registersBareFamilyName('ThemeSans'), isTrue);
    });

    test('registers a platform default the SDK ships no font for', () {
      // Nothing else can provide it, a stand-in beats placeholder blocks.
      expect(policy.registersBareFamilyName('CupertinoSystemText'), isTrue);
    });

    test('leaves a platform default the SDK ships a font for alone', () {
      // A dependency usually bundles a single weight of it, the SDK ships all
      // of them, so the SDK font stays closer to a real device.
      expect(policy.registersBareFamilyName('Roboto'), isFalse);
    });
  });

  group('FontLoadingPolicy.platformAware', () {
    test('provides the platform default families', () {
      final policy = FontLoadingPolicy.platformAware();

      expect(policy.familiesToProvide, equals(platformDefaultFontFamilies()));
      expect(policy.sdkFamilies, equals(sdkFontFamilies()));
    });
  });

  group('FontLoadingPolicy.manifestOnly', () {
    test('provides nothing on top of the manifest', () {
      const policy = FontLoadingPolicy.manifestOnly();

      expect(policy.familiesToProvide, isEmpty);
      expect(policy.registersBareFamilyName('Roboto'), isTrue);
    });
  });
}
