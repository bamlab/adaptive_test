import 'package:flutter/material.dart';

class AppText extends StatelessWidget {
  final String text;
  const AppText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        package: 'multi_packages_example_theme',
        fontFamily: 'Roboto',
      ),
    );
  }
}
