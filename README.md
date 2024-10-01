# Adaptive Test

<p>
  <a href="https://apps.theodo.com">
  <img  alt="logo" src="https://raw.githubusercontent.com/bamlab/theodo_analysis/main/doc/theodo_apps_white.png" width="200"/>
  </a>
  </br>
  <p>Devtools to write stunning widget test in Flutter.</br> Made by <a href="https://apps.theodo.com">Theodo Apps</a> ❤️💙💛.</p>
</p>

![Example](https://raw.githubusercontent.com/bamlab/adaptive_test/main/doc/example.png)

## Table of Contents
1. [Features](#features)
2. [Getting Started](#getting-started)
3. [Usage](#usage)
   - [Rendering Custom Fonts](#rendering-custom-fonts)
   - [Setting Up Test Devices](#setting-up-test-devices)
   - [Configuring Difference Threshold](#configuring-difference-threshold)
   - [Enforcing Test Platform](#enforcing-test-platform)
   - [Writing a Test](#writing-a-test)
4. [Migration Guide](#migration-guide)
5. [Additional Information](#additional-information)

## Features

Use this package in your tests to:
- Generate golden files for different devices during tests
- Load fonts
- Set window sizes and pixel density
- Await image rendering
- Render physical and system UI layers
- Render a keyboard during tests
- Set a preferred OS for running tests
- Configure a difference tolerance threshold for file comparison

## Getting Started

1. Add `adaptive_test` to your dev dependencies.

2. Create a `flutter_test_config.dart` file at the root of your `test` folder with a `testExecutable` function:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  await testMain();
}
```

For more information, see the [official Flutter documentation](https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html).

## Usage

### Rendering Custom Fonts

1. Add your fonts to your app assets folders.
2. Add your fonts to your Flutter assets in `pubspec.yaml`:

```yaml
flutter:
  fonts:
  - family: Roboto
    fonts:
      - asset: fonts/Roboto-Black.ttf
```

3. In your `flutter_test_config.dart`, call `loadFonts()`:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await loadFonts();
  await testMain();
}
```

> ℹ️ `loadFonts()` loads fonts from `pubspec.yaml` and from every separate package dependency as well.

### Setting Up Test Devices

1. Define a set of device variants:

```dart
final defaultDeviceConfigs = {
  iPhone13,
  pixel5,
};
```

2. Use the `AdaptiveTestConfiguration` singleton to set variants:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  AdaptiveTestConfiguration.instance
    ..setDeviceVariants(defaultDeviceConfigs);
  await loadFonts();
  await testMain();
}
```

### Configuring Difference Threshold

To allow for small pixel differences between processors, add `setupFileComparatorWithThreshold()` to your `flutter_test_config.dart`:

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

### Enforcing Test Platform

Configure `AdaptiveTestConfiguration` to enforce a specific test platform:

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

To skip tests instead of throwing an error on unintended platforms:

```dart
AdaptiveTestConfiguration.instance
  ..setEnforcedTestPlatform(TargetPlatform.macOS)
  ..setFailTestOnWrongPlatform(false)
  ..setDeviceVariants(defaultDeviceConfigs);
```

### Writing a Test

Use the `testAdaptiveWidgets` function:

```dart
void main() {
  testAdaptiveWidgets(
    'Test description',
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

## Migration Guide

</details>
<details>
<summary>Migrating to version 0.7.x</summary>
Version 0.7.0 introduces several breaking changes and new features:

1. **Breaking Change**: `loadFonts()` no longer accepts a `packages` argument. `loadFontsFromPackage()` was removed.
   - Update your `flutter_test_config.dart`:
     ```dart
     // Old
     await loadFonts('my_package');
     // or
     await loadFontsFromPackage(
       package: Package(
         name: 'my_package',
         relativePath: '../package',
       ),
     );

     // New
     await loadFonts();
     ```
   - `loadFonts()` now supports custom icon fonts like material_symbols_icons.

2. **Breaking Change**: `WindowConfigData` now includes a `keyboardName` property.
   - Update your custom device configurations to include this new property.
</details>
<details>
<summary>Migrating to version 0.5.x</summary>

Version 0.5.0 introduces a new default file name for goldens that's compatible with Windows file systems. To rename your existing golden files, use the following script:

```bash
#!/bin/bash

rename_files_in_preview() {
    find . -type d -name "preview" | while read -r dir; do
        echo "Processing directory: $dir"
        find "$dir" -type f | while read -r file; do
            new_name=$(echo "$file" | sed 's/:/-/g')
            if [ "$file" != "$new_name" ]; then
                mv "$file" "$new_name"
                echo "Renamed $file to $new_name"
            fi
        done
    done
}

rename_files_in_preview
```

Save this script as a `.sh` file and run it from your project root directory.

</details>

## Additional Information

We welcome feedback, issues, contributions, and suggestions! Feel free to contribute to the development of this package.

👉 About Theodo Apps

We are a 130 people company developing and designing universal applications with React Native and Flutter using the Lean & Agile methodology. To get more information on the solutions that would suit your needs, feel free to get in touch by email or through or contact form!

We will always answer you with pleasure 😁


