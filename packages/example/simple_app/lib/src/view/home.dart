import 'package:flutter/material.dart';
import 'package:simple_app_example/generated/l10n.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).app_title),
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
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: AppLocalizations.of(context).say_hi,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
