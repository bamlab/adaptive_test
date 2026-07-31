import 'package:adaptive_test/adaptive_test.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

  group('registerFontFamily', () {
    test('returns the family it registered', () async {
      final family = await registerFontFamily('AFamily', const []);

      expect(family, 'AFamily');
    });
  });
}
