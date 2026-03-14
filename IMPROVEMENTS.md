# Improvement Analysis for `adaptive_test`

## 1. Testing — Nearly Non-Existent

The test suite (`test/adaptive_test_test.dart`) contains a single placeholder test (`expect(true, isTrue)`). For a testing utility package, this is a significant gap. Key areas that should be tested:

- **`WindowConfigData`** — `copyWith`, equality, computed fields (`physicalSize`, `viewInsets`, `padding`)
- **`AdaptiveTestConfiguration`** — singleton behavior, `deviceVariant` throw when unset, `shouldSkipTest` logic
- **`ViewPaddingImpl`** — multiplication operator, `copyWith` extension
- **`LocalFileComparatorWithThreshold`** — threshold comparison logic
- **`loadFonts()`** — font manifest parsing
- **Widget layers** — `HardwareLayer`, `KeyboardLayer`, `SystemNavBarLayer` rendering
- **`awaitImages()`** — precaching behavior across `Image`, `FadeInImage`, `DecoratedBox`

## 2. Mutable Global State in `devices_data.dart`

All device presets (`iPhone8`, `iPhone13`, `pixel5`, etc.) are declared as `final` (not `const`) top-level variables. Since `WindowConfigData` is not `const`-constructible, these are mutable global references. If a user accidentally reassigns one, it silently breaks for all tests. Consider making these getters or documenting immutability expectations more clearly.

## 3. Fragile Keyboard Detection (`keyboard_layer.dart:72-73`)

```dart
final focus = focusedWidget as Focus;
final focusNeedsInput = focus.debugLabel == '$EditableText';
```

This casts unconditionally to `Focus` and checks keyboard need via a `debugLabel` string comparison. This is fragile because:
- The cast will crash if the focused widget is not a `Focus`
- `debugLabel` is a debug-only property that could change across Flutter versions
- A more robust approach would walk the focus tree looking for `EditableText` ancestors

## 4. Unused Dependencies

- **`cupertino_icons: ^1.0.5`** — Runtime dependency that seems unnecessary for a testing package. Typically needed for `CupertinoIcons` in app UI, not golden test generation.
- **`file: ^7.0.0`** and **`platform: ^3.1.0`** — Declared as dependencies but don't appear to be imported anywhere in the source code. May be leftover from earlier versions.

## 5. `copyWith` Bug — Cannot Clear Optional Fields

`WindowConfigData.copyWith()` uses the `??` pattern for all nullable fields (`notchSize`, `dynamicIsland`, `punchHole`, `systemNavBar`). This means there's no way to create a variant that *removes* a feature (e.g., derive a "Pixel without punch hole" from `pixel5`). A common pattern is to use a sentinel value or `Optional<T>` wrapper.

## 6. Error Handling in `setupFileComparatorWithThreshold`

The function throws a generic `Exception` if `goldenFileComparator` isn't a `LocalFileComparator`. This could happen in CI environments using different comparators. A more graceful approach would be to log a warning and skip setup, or provide an explicit CI-compatible path.

## 7. Typo in Log Message (`target_platform_extension.dart:17`)

```dart
'Tests are intended to be runned on linux, macOS or windows'
```

"runned" should be "run".

## 8. Singleton Pattern Could Use a `reset()` Method

`AdaptiveTestConfiguration` is a singleton with no way to reset state between test suites. For library testing or advanced setups, a `reset()` or `@visibleForTesting` tear-down would help avoid state leakage.

## 9. Missing Device Configurations

Notable missing devices:
- **iPhone SE** (small form factor, important for layout testing)
- **iPhone Pro Max** variants (largest iOS screens)
- **Foldable devices** (Samsung Galaxy Fold — growing market segment)
- **Android tablets** (no Android tablet equivalent to `iPadPro`)
- **Landscape orientations** (all devices are portrait-only)

## 10. `awaitImages()` Doesn't Handle `SvgPicture` or `NetworkImage`

The `awaitImages` extension handles `Image`, `FadeInImage`, and `DecoratedBox`, but doesn't handle SVG images (common via `flutter_svg`) or `NetworkImage` providers. This could lead to missing images in golden files.

## 11. SDK Constraint is Very Broad

```yaml
environment:
  sdk: '>=3.0.5 <4.0.0'
  flutter: '>=1.17.0'
```

The `flutter: '>=1.17.0'` minimum is from 2020 and almost certainly incompatible (the code uses `FakeViewPadding`, sealed classes, etc.). Should be bumped to reflect actual minimum Flutter version (likely `>=3.10.0` or higher).

## 12. `expectGolden` Uses Type Name for File Naming

```dart
final name = ReCase('$T');
```

Using the generic type `T` as part of the golden file name is clever but error-prone — if a user wraps their widget differently, the golden file name changes silently, causing phantom test failures.

## 13. No Support for Accessibility Testing

The package already wraps widgets in device-specific configurations. Natural extensions:
- Large font / text scaling factor variants
- High contrast mode
- Screen reader semantics validation

## 14. Documentation

- `public_member_api_docs` lint is disabled in `analysis_options.yaml`. Some public APIs (like `ViewPaddingImpl`, `FakeViewPaddingX`) are undocumented.
- The README could benefit from a "migration guide" section given the breaking changes in recent versions (0.8.0, 0.10.0).
