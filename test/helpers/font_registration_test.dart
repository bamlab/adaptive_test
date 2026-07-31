import 'package:adaptive_test/adaptive_test.dart';
import 'package:adaptive_test/src/helpers/platform_fonts.dart';
import 'package:flutter_test/flutter_test.dart';

import 'font_test_helpers.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('registerFontFamily', () {
    test('returns the family it registered', () async {
      final family = await registerFontFamily('AFamily', const []);

      expect(family, 'AFamily');
    });

    test('registers the assets it is given', () async {
      // A proportional face, so that the width heuristic can tell it apart
      // from the placeholder font — an icon font would not do.
      final proportionalFace = sdkFontFilesByFamily().entries.firstWhere(
            (entry) => platformDefaultFontFamilies().contains(entry.key),
          );

      await registerFontFamily(
        'ARealFamily',
        proportionalFace.value.toByteData(),
      );

      expect(rendersWithARealFont('ARealFamily'), isTrue);
    });
  });
}
