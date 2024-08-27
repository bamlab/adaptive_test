import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../window_size.dart';
import '../../window_configuration.dart';

class KeyboardLayer extends StatelessWidget {
  const KeyboardLayer({
    Key? key,
    required this.tester,
    required this.child,
  }) : super(key: key);

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
    Key? key,
    required this.tester,
  }) : super(key: key);
  final WidgetTester tester;

  @override
  State<KeyboardDisplayer> createState() => _KeyboardDisplayerState();
}

class _KeyboardDisplayerState extends State<KeyboardDisplayer> {
  bool displayKeyboard = false;
  late void Function() listener;

  @override
  void initState() {
    listener = () {
      final windowConfig = WindowConfig.of(context);
      if (!mounted) {
        return widget.tester.configureClosedKeyboardWindow(windowConfig);
      }

      setState(() {
        final deviceHasKeyboard = windowConfig.keyboardSize != null;
        if (!deviceHasKeyboard) {
          displayKeyboard = false;
          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }

        final focusedWidget =
            FocusManager.instance.primaryFocus?.context?.widget;
        if (focusedWidget == null) {
          displayKeyboard = false;
          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }

        final focus = focusedWidget as Focus;
        final focusNeedsInput = focus.debugLabel == '$EditableText';

        if (!focusNeedsInput) {
          displayKeyboard = false;
          return widget.tester.configureClosedKeyboardWindow(windowConfig);
        }
        displayKeyboard = true;
        return widget.tester.configureOpenedKeyboardWindow(windowConfig);
      });
    };

    FocusManager.instance.addListener(listener);
    super.initState();
  }

  @override
  void dispose() {
    FocusManager.instance.removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final windowConfig = WindowConfig.of(context);

    if (!displayKeyboard) return const SizedBox();
    return Positioned(
      bottom: 0,
      child: Image.asset(
        'assets/keyboards/${windowConfig.name}.png',
        height: windowConfig.keyboardSize?.height,
        width: windowConfig.keyboardSize?.width,
        package: 'adaptive_test_extended',
        fit: BoxFit.cover,
      ),
    );
  }
}
