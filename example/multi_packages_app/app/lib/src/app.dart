import 'package:flutter/material.dart';

import 'view/home.dart';

class App extends StatelessWidget {
  const App({Key? key, this.themeMode}) : super(key: key);
  final ThemeMode? themeMode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptative golden example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'roboto',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        fontFamily: 'roboto',
      ),
      themeMode: themeMode,
      home: const HomeLayout(),
    );
  }
}
