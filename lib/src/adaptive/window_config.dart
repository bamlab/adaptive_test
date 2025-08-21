import 'package:adaptive_test/src/adaptive/window_config_data/window_config_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class WindowVariant extends ValueVariant<WindowConfigData> {
  WindowVariant(this.windowConfigs) : super(windowConfigs);

  final Set<WindowConfigData> windowConfigs;

  @override
  String describeValue(WindowConfigData value) => value.name;
}

/// Establish a subtree in which adaptive window resolves to the given data.
/// Use `WindowConfig.of(context)` to retrieve the data in any child widget.
///
/// See also: [WindowConfigData].
class WindowConfig extends InheritedWidget {
  const WindowConfig({
    required this.windowConfig,
    required super.child,
    super.key,
  });

  final WindowConfigData windowConfig;

  static WindowConfigData of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<WindowConfig>()
        ?.windowConfig;
    assert(result != null, 'No WindowConfig found in context');

    // ignore: avoid-non-null-assertion, protected by assertion
    return result!;
  }

  @override
  bool updateShouldNotify(WindowConfig oldWidget) =>
      oldWidget.windowConfig != windowConfig;
}
