import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final TextStyle? style;
  const AppTextField({this.labelText, this.style, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
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
