import 'package:flutter/material.dart';
import 'package:multi_packages_example_theme/main.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText('Adaptive Golden'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/dash.png',
                height: 56,
                width: 56,
              ),
              const SizedBox(width: 20),
              const Expanded(
                child: AppTextField(labelText: 'Say hi !'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
