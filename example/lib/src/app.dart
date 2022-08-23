import 'view/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptative golden example',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'roboto',
      ),
      home: const HomeLayout(),
    );
  }
}
