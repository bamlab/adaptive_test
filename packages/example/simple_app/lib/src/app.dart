import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_app_example/generated/l10n.dart';

import 'view/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key, @visibleForTesting this.testLocale}) : super(key: key);
  final Locale? testLocale;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptative golden example',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate
      ],
      supportedLocales: AppLocalizations.delegate.supportedLocales,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        fontFamily: testLocale?.languageCode.contains('ar') ?? false ? 'Dubai' : 'Roboto',
      ),
      locale: testLocale,
      home: const HomeLayout(),
    );
  }
}
