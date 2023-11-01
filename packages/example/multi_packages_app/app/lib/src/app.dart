import 'view/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({this.themeData, Key? key}) : super(key: key);
  final ThemeData? themeData;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptative golden example',
      theme: themeData ??
          ThemeData(
            primarySwatch: Colors.blue,
            brightness: Brightness.light,
            fontFamily: 'roboto',
          ),
      home: const HomeLayout(),
    );
  }
}
