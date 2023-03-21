import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/domain/database/firestore.dart';

import '../../../infrastructure/firestore/basic_repo.dart';
import '../shared/shared.dart';

class PersonalHistoryScreen extends StatefulWidget {

  const PersonalHistoryScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalHistoryScreenState();
}

class _PersonalHistoryScreenState extends State<PersonalHistoryScreen> {

  final dataRepository = FirestoreBasicFieldRepository('users');
  final personalHistory = {
    for (var history in [
      'diabetes',
      'hypertension',
      'hyperuricemia',
      'gout',
      'hematuria',
      'proteinuria',
      'renalColic',
      'frequentUrination'
    ]) history: false
  };

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
              state: personalHistory,
              field: 'diabetes'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hypertension',
              state: personalHistory,
              field: 'hypertension'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hyperuricemia',
              state: personalHistory,
              field: 'hyperuricemia'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Metabolic Arthritis, Gout',
              state: personalHistory,
              field: 'gout'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Hematuria',
              state: personalHistory,
              field: 'hematuria'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Proteinuria',
              state: personalHistory,
              field: 'proteinuria'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Renal colic',
              state: personalHistory,
              field: 'renalColic'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Frequent urination',
              state: personalHistory,
              field: 'frequentUrination'
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Next'))
        ],
      ),
    ),
  );

  void _submit() async {
    dataRepository.update(
        dataType: DataType.healthData,
        json: personalHistory
    );
    context.router.replaceNamed('/personal-habits');
  }
}