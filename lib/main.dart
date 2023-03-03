import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../presentation/router/router.gr.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppRouter appRouter = AppRouter();
  await Firebase.initializeApp();

  runApp(
    MyApp(
      appRouter: appRouter
    )
  );
}

class MyApp extends StatelessWidget {

  final AppRouter _appRouter;

  const MyApp({super.key, required AppRouter appRouter})
    : _appRouter = appRouter;

  static const String title = 'CKD Care';

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: title,
    theme: ThemeData(
      useMaterial3: true,
      primarySwatch: Colors.blue,
    ),
    routerDelegate: _appRouter.delegate(),
    routeInformationParser: _appRouter.defaultRouteParser(),
    builder: (context, router) => router!
  );
}