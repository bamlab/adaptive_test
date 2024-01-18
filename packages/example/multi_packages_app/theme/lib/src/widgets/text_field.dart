import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final String? labelText;
  const AppTextField({this.labelText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: labelText,
        labelStyle: const TextStyle(
          package: 'multi_packages_example_theme',
          fontFamily: 'Roboto',
        ),
      ),
    );
  }
}
