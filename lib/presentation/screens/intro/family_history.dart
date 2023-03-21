import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/domain/database/firestore.dart';

import '../../../infrastructure/firestore/basic_repo.dart';
import '../shared/shared.dart';

class FamilyHistoryScreen extends StatefulWidget {

  const FamilyHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FamilyHistoryScreenState();
}

class _FamilyHistoryScreenState extends State<FamilyHistoryScreen> {

  final firestoreRepository = FirestoreBasicFieldRepository('users');
  final otherFamilyHistoryEditingController = TextEditingController();
  final familyHistory = {
    for (var history in [
      'polycystic',
      'igAN',
      'liddle',
      'others'
    ]) history: false
  };

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
            state: familyHistory,
            field: 'polycystic'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Immunoglobulin A nephropathy (IgAN)',
              state: familyHistory,
              field: 'igAN'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Liddle\'s syndrome',
              state: familyHistory,
              field: 'liddle'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Others',
              state: familyHistory,
              field: 'others'
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Next'))
        ],
      ),
    ),
  );

  void _submit() async {
    await firestoreRepository.update(
        dataType: DataType.healthData,
        json: familyHistory
    );
    context.router.replaceNamed('/personal-history');
  }
}