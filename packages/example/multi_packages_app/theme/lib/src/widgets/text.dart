import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const AppText(this.text, {this.style, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style?.copyWith(
            package: 'multi_packages_example_theme',
            fontFamily: 'Roboto',
          ) ??
          const TextStyle(
            package: 'multi_packages_example_theme',
            fontFamily: 'Roboto',
          ),
    );
  }
}
