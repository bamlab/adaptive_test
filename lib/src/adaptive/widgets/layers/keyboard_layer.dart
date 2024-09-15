import 'package:adaptive_test/src/adaptive/window_configuration.dart';
import 'package:adaptive_test/src/adaptive/window_size.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

class KeyboardLayer extends StatelessWidget {
  const KeyboardLayer({
    required this.tester,
    required this.child,
    super.key,
  });

  final Widget child;
  final WidgetTester tester;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          child,
          KeyboardDisplayer(tester: tester),
        ],
      ),
    );
  }
}

/// Will display a keyboard if an `EditableText` is focused.
class KeyboardDisplayer extends StatefulWidget {
  const KeyboardDisplayer({
    required this.tester,
    super.key,
  });
  final WidgetTester tester;

  @override
  State<KeyboardDisplayer> createState() => _KeyboardDisplayerState();
}

class _KeyboardDisplayerState extends State<KeyboardDisplayer> {
  bool _displayKeyboard = false;
  late void Function() _listener;

  @override
  void initState() {
    super.initState();
    _listener = () {
      // ignore: avoid-inherited-widget-in-initstate, it's in a listner
      final windowConfig = WindowConfig.of(context);
      if (!mounted) {
        return widget.tester.configureClosedKeyboardWindow(windowConfig);
      }

      setState(() {
        final deviceHasKeyboard = windowConfig.keyboardSize != null;
        if (!deviceHasKeyboard) {
          _displayKeyboard = false;

          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }

        final focusedWidget =
            FocusManager.instance.primaryFocus?.context?.widget;
        if (focusedWidget == null) {
          _displayKeyboard = false;

          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }

        final focus = focusedWidget as Focus;
        final focusNeedsInput = focus.debugLabel == '$EditableText';

        if (!focusNeedsInput) {
          _displayKeyboard = false;

          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }
        _displayKeyboard = true;

        return widget.tester.configureOpenedKeyboardWindow(windowConfig);
      });
    };

    FocusManager.instance.addListener(_listener);
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    if (!_displayKeyboard) return const SizedBox();

    return Positioned(
      bottom: 0,
      child: Image.asset(
        windowConfig.keyboardName,
        height: windowConfig.keyboardSize?.height,
        width: windowConfig.keyboardSize?.width,
        package: 'adaptive_test',
        fit: BoxFit.cover,
      ),
    );
  }
}
