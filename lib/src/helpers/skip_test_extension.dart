import 'package:adaptive_test/adaptive_test.dart';
import 'package:adaptive_test/src/helpers/target_platform_extension.dart';

/// Extension on [AdaptiveTestConfiguration] to determine if a test should be
/// skipped based on the [AdaptiveTestConfiguration.enforcedTestPlatform] and
/// [AdaptiveTestConfiguration.failTestOnWrongPlatform] values.
extension ShouldSkipAdaptiveTest on AdaptiveTestConfiguration {
  /// If [AdaptiveTestConfiguration.enforcedTestPlatform] is defined and the
  /// runtime platform does not match the enforced platform, the test will be
  /// skipped if [AdaptiveTestConfiguration.failTestOnWrongPlatform] is false.
  ///
  /// This extension is used to determine if a test should be skipped based on the
  /// [AdaptiveTestConfiguration.enforcedTestPlatform] and
  /// [AdaptiveTestConfiguration.failTestOnWrongPlatform] values.
  bool get shouldSkipTest {
    final configuration = AdaptiveTestConfiguration.instance;
    final enforcedTestPlatform = configuration.enforcedTestPlatform;

    if (enforcedTestPlatform != null &&
        !enforcedTestPlatform.isRuntimePlatform) {
      return !configuration.failTestOnWrongPlatform;
    }

    return false;
  }
}
