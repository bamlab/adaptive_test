import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    this.labelText,
    this.style = const TextStyle(
      package: 'multi_packages_example_theme',
      fontFamily: 'Roboto',
    ),
    super.key,
  });

  final String? labelText;
  final TextStyle style;
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        labelStyle: style,
      ),
      style: style,
    );
  }
}
