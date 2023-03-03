import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Hi, ${FirebaseAuth.instance.currentUser!.displayName}!'),
              const Text('Before we start, please fill out some information.'),
              const Text('(All the information can be edited afterwards.)'),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: _nextStep,
                  child: const Text('Next'))
            ],
          )));

  void _nextStep() => context.router.replaceNamed('/basic-info');
}
