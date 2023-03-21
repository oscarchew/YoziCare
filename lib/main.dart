import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../presentation/router/router.gr.dart';
import 'presentation/router/router.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp(appRouter: AppRouter(
      checkIfAlreadyLoggedIn: CheckIfAlreadyLoggedIn()
  )));
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
      routeInformationParser: _appRouter.defaultRouteParser()
  );
}