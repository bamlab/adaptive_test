import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  final TextStyle style;
  const AppTextField({
    this.labelText,
    this.style = const TextStyle(
      package: 'multi_packages_example_theme',
      fontFamily: 'Roboto',
    ),
    Key? key,
  }) : super(key: key);

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
