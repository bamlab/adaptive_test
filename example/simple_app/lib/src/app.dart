import 'package:flutter/material.dart';
import 'package:simple_app_example/src/view/home.dart';

class App extends StatelessWidget {
  const App({
    super.key,
    this.useFadeInImage = false,
  });

  final bool useFadeInImage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptative golden example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'roboto',
      ),
      home: HomeLayout(
        useFadeInImage: useFadeInImage,
      ),
    );
  }
}
