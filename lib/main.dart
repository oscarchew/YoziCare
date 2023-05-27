import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'presentation/router/router.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:localization/localization.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(appRouter: AppRouter()));
}

class MyApp extends StatelessWidget {

  final AppRouter _appRouter;

  const MyApp({super.key, required AppRouter appRouter})
      : _appRouter = appRouter;

  static const String title = 'CKD Care';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]
    );
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];
    return MaterialApp.router(
      title: title,

      // Localization
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        LocalJsonLocalization.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('zh', 'TW'),
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (supportedLocales.contains(locale)) return locale;
        if (locale?.languageCode == 'zh') return const Locale('zh', 'TW');
        return const Locale('en', 'US');
      },

      // Theme
      theme: ThemeData(
          useMaterial3: true,
          primarySwatch: Colors.blue,
          unselectedWidgetColor: Colors.lightGreen,
          fontFamily: 'GenWanMin'
      ),

      // Routing
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}