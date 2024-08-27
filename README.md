<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A Flutter package to generate adaptive golden files during widget tests.

> This package is in beta. Use it with caution and [file any potential issues here](https://github.com/bamlab/adaptive_test/issues).

<p>
  <img  alt="Example" src="https://raw.githubusercontent.com/bamlab/adaptive_test/main/doc/example.png"/>
</p>

## Features
Use this package in your test to:
- Generated golden files during test for different devices.
- Load fonts.
- Set window sizes and pixel density.
- Await for images rendering.
- Render Physical and system UI layers.
- Render a keyboard during tests.
- Set a preferred OS to run the tests.
- Configure a difference tolerance threshold for files comparison.

## Getting started

Add `adaptive_test` to your dev dependencies

At the root of your `test` folder create a `flutter_test_config.dart` file with a `testExecutable` function.

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await testMain();
}
```

See the [official doc](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html).

## Usage

### To render custom fonts:
- Add your fonts to your app packages.assets folders.
- Add your fonts to your flutter packages.assets.
```yaml
flutter:
  fonts:
  - family: Roboto
    fonts:
      - asset: fonts/Roboto-Black.ttf
...
```
- In your flutter_test_config, call `loadFonts()`.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadFonts();
  await testMain();
}
```

Alternatively you can load fonts from a separate package by specifying its name and path:

```dart
await loadFontsFromPackage(
  package: Package(
    name: 'my_theme_package',
    relativePath: '../theme',
  ),
);
```

### Setup devices to run test on
Define a set of device variant corresponding to your definition of done.
```dart
final defaultDeviceConfigs = {
  iPhone13,
  pixel5,
};
```
Use the `AdaptiveTestConfiguration` singleton to set variants.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  await testMain();
}
```

### (Optional) Allow a differences threshold in golden files comparators
Source : [The Rows blog](https://rows.com/blog/post/writing-a-localfilecomparator-with-threshold-for-flutter-golden-tests)
Different processor architectures can lead to a small differences of pixel between a files generated on an ARM processor and an x86 one.
Eg: a MacBook M1 and an intel one.

We can allow the tests to passe if the difference is small. To do this, add `setupFileComparatorWithThreshold()` to your flutter_test_config.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
```

### (Optional) Enforce a Platform for the test to run on
Different OS render golden files with small differences of pixel.
See the [flutter issue](https://github.com/flutter/flutter/issues/36667).

You can configure `AdaptiveTestConfiguration` singleton to make tests throw if they are run on an unintended platform.
```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setEnforcedTestPlatform(TargetPlatform.macOS)
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  setupFileComparatorWithThreshold();
  await testMain();
}
```

As an alternative you can use [Alchemist](https://pub.dev/packages/alchemist).

### Write a test
Use `testAdaptiveWidgets` function. It take a callback with two arguments, `WidgetTester` and `WindowConfigData`.

`WindowConfigData` is a data class that describes a devices. It's used as a test variant.

```dart
void main() {
  testAdaptiveWidgets(
    'Test description',
    (tester, variant) async {},
  );
}
```

Wrap the widget you want to test with `AdaptiveWrapper`.

```dart
await tester.pumpWidget(
  AdaptiveWrapper(
    windowConfig: variant,
    tester: tester,
    child: const App(),
  ),
);
```

Use the `WidgetTester` extension `expectGolden` to generate golden files.

```dart
await tester.expectGolden<App>(variant);
```

A basic test should looks like this:
```dart
void main() {
  testAdaptiveWidgets(
    '$App render without regressions',
    (tester, variant) async {
      await tester.pumpWidget(
        AdaptiveWrapper(
          windowConfig: variant,
          tester: tester,
          child: const App(),
        ),
      );

      await tester.expectGolden<App>(variant);
    },
  );
}
```

## Migration to 0.5.x
The 0.5.0 version introduces a new default file name for goldens that doesn't use characters unsupported by Windows file system.

To ease the migration, we provide a script that will rename your goldens files to the new format:
```bash
#!/bin/bash

# Function to rename files in directories named "preview"
rename_files_in_preview() {
    # Find directories named "preview"
    find . -type d -name "preview" | while read -r dir; do
        echo "Processing directory: $dir"
        # Find files within these directories
        find "$dir" -type f | while read -r file; do
            # New filename by replacing ':' with '-'
            new_name=$(echo "$file" | sed 's/:/-/g')
            if [ "$file" != "$new_name" ]; then
                mv "$file" "$new_name"
                echo "Renamed $file to $new_name"
            fi
        done
    done
}

# Call the function
rename_files_in_preview()
```

You can add the script in a `.sh` file and run it from your project root directory.

## Additional information

This package is still in early stage of development.
After using it in multiple projects, we wanted to open-source it.

Feedbacks, issues, contributions and suggestions are more than welcomed! 😁

## 👉 About Bam

We are a 100 people company developing and designing multiplatform applications with [React Native](https://www.bam.tech/expertise/react-native) and [Flutter](https://www.bam.tech/expertise/flutter) using the Lean & Agile methodology. To get more information on the solutions that would suit your needs, feel free to get in touch by [email](mailto://contact@bam.tech) or through or [contact form](https://www.bam.tech/contact)!

We will always answer you with pleasure 😁
