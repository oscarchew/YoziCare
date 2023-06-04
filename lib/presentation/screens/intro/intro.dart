import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';

@RoutePage()
class IntroScreen extends StatefulWidget {

  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  final firestoreRepository = FirestoreArrayFieldRepository('users');

  @override
  void initState() {
    firestoreRepository.addMultiple(
        dataTypes: [DataType.eGFR, DataType.hydration, DataType.urination],
        jsons: []
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('${'hi'.i18n()}${FirebaseAuth.instance.currentUser!.displayName}${'exclamation-mark'.i18n()}'),
              Text('fill-your-information'.i18n()),
              Text('information-is-editable'.i18n()),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightGreen
                  ),
                  onPressed: () => context.router.replaceNamed('/basic-info'),
                  icon: const Icon(Icons.navigate_next),
                  label: Text('next'.i18n())
              ),
            ],
          )
      )
  );
}
