import 'package:flutter/material.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key, this.useFadeInImage = false}) : super(key: key);

  final bool useFadeInImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adaptative Golden'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              useFadeInImage
                  ? const FadeInImage(
                      placeholder: AssetImage('assets/dash.png'),
                      image: AssetImage('assets/dash.png'),
                      height: 56,
                      width: 56,
                    )
                  : Image.asset(
                      'assets/dash.png',
                      height: 56,
                      width: 56,
                    ),
              const SizedBox(width: 20),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Say hi !',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
