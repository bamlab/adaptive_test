import 'view/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    this.useFadeInImage = false,
  }) : super(key: key);

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
