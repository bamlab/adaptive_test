import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:simple_app_example/generated/l10n.dart';

import 'view/home.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultLocale = SchedulerBinding.instance.platformDispatcher.locale;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adaptive golden example',
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
        fontFamily:
            defaultLocale.languageCode.contains('ar') ? 'Dubai' : 'Roboto',
      ),
      locale: defaultLocale,
      home: const HomeLayout(),
    );
  }
}
