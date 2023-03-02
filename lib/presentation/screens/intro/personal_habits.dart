import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../shared/shared.dart';

class PersonalHabitsScreen extends StatefulWidget {

  const PersonalHabitsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalHabitsScreenState();
}

enum PersonalHabit {
  painKillerAbuse, antibioticsAbuse, smoking, drinking
}

class _PersonalHabitsScreenState extends State<PersonalHabitsScreen> {

  final state = List.filled(4, false);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Family medical history:'),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Painkiller abuse',
              state: state,
              index: PersonalHabit.painKillerAbuse.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Antibiotics abuse',
              state: state,
              index: PersonalHabit.antibioticsAbuse.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Smoking',
              state: state,
              index: PersonalHabit.smoking.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Drinking',
              state: state,
              index: PersonalHabit.drinking.index
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Next'))
        ],
      ),
    ),
  );

  void _submit() async {
    // Add data to Firestore
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final json = {
      'isPainkillerAbuse': state[PersonalHabit.painKillerAbuse.index],
      'isAntibioticsAbuse': state[PersonalHabit.antibioticsAbuse.index],
      'isSmoking': state[PersonalHabit.smoking.index],
      'isDrinking': state[PersonalHabit.drinking.index],
    };
    await docUser.update(json);

    // Jump to the next screen
    context.router.replaceNamed('/home');
  }
}