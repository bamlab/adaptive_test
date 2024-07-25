import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({super.key, this.useFadeInImage = false});

  final bool useFadeInImage;
  @override
  Widget build(BuildContext context) {
    const assetName = 'assets/dash.png';

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.image),
            SizedBox(width: 12),
            Text('Adaptive Golden'),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (useFadeInImage)
                const FadeInImage(
                  placeholder: AssetImage(assetName),
                  image: AssetImage(assetName),
                  height: 56,
                  width: 56,
                )
              else
                Image.asset(
                  assetName,
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
