import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../shared/shared.dart';

class PersonalHistoryScreen extends StatefulWidget {

  const PersonalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalHistoryScreenState();
}

enum PersonalHistory {
  diabetes, hypertension, hyperuricemia, gout,
  hematuria, proteinuria, renalColic, frequentUrination
}

class _PersonalHistoryScreenState extends State<PersonalHistoryScreen> {

  final state = List.filled(8, false);

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Personal medical history:'),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Diabetes',
              state: state,
              index: PersonalHistory.diabetes.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hypertension',
              state: state,
              index: PersonalHistory.hypertension.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hyperuricemia',
              state: state,
              index: PersonalHistory.hyperuricemia.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Metabolic Arthritis, Gout',
              state: state,
              index: PersonalHistory.gout.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hematuria',
              state: state,
              index: PersonalHistory.hematuria.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Proteinuria',
              state: state,
              index: PersonalHistory.proteinuria.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Renal colic',
              state: state,
              index: PersonalHistory.renalColic.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Frequent urination',
              state: state,
              index: PersonalHistory.frequentUrination.index
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
      'hasDiabetes': state[PersonalHistory.diabetes.index],
      'hasHypertension': state[PersonalHistory.hypertension.index],
      'hasHyperuricemia': state[PersonalHistory.hyperuricemia.index],
      'hasGout': state[PersonalHistory.gout.index],
      'hasHematuria': state[PersonalHistory.hematuria.index],
      'hasProteinuria': state[PersonalHistory.proteinuria.index],
      'hasRenalColic': state[PersonalHistory.renalColic.index],
      'hasFrequentUrination': state[PersonalHistory.frequentUrination.index],
    };
    await docUser.update(json);

    // Jump to the next screen
    context.router.replaceNamed('/personal-habits');
  }
}