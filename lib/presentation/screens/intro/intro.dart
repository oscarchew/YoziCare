import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';

class IntroScreen extends StatefulWidget {

  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  final firestoreRepository = FirestoreArrayFieldRepository('users');

  @override
  Future<void> initState() async {
    await initializeEGFR();
    await initializeHydration();
    await initializeUrination();
    super.initState();
  }

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
                  onPressed: () => context.router.replaceNamed('/basic-info'),
                  child: const Text('Next'))
            ],
          )
      )
  );

  Future<void> initializeEGFR() async =>
      await firestoreRepository.add(dataType: DataType.eGFR);

  Future<void> initializeHydration() async =>
      await firestoreRepository.add(dataType: DataType.hydration);

  Future<void> initializeUrination() async =>
      await firestoreRepository.add(dataType: DataType.urination);
}
