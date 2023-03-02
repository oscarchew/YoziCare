import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../shared/shared.dart';

class FamilyHistoryScreen extends StatefulWidget {

  const FamilyHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FamilyHistoryScreenState();
}
enum FamilyHistory {
  polycystic, igAN, liddle, others
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {

  final otherFamilyHistoryEditingController = TextEditingController();
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
            title: 'Polycystic kidney disease',
            state: state,
            index: FamilyHistory.polycystic.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Immunoglobulin A nephropathy, IgAN',
              state: state,
              index: FamilyHistory.igAN.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Liddle\'s syndrome',
              state: state,
              index: FamilyHistory.liddle.index
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Others',
              state: state,
              index: FamilyHistory.others.index
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
      'hasPolycystic': state[FamilyHistory.polycystic.index],
      'hasIgAN': state[FamilyHistory.igAN.index],
      'hasLiddle': state[FamilyHistory.liddle.index],
      'hasOthers': state[FamilyHistory.others.index],
    };
    await docUser.update(json);

    // Jump to the next screen
    context.router.replaceNamed('/personal-history');
  }
}