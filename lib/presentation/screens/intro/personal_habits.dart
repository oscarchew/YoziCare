import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gdsc/domain/database/firestore.dart';

import '../../../infrastructure/firestore/basic_repo.dart';
import '../shared/shared.dart';

class PersonalHabitsScreen extends StatefulWidget {

  const PersonalHabitsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PersonalHabitsScreenState();
}

class _PersonalHabitsScreenState extends State<PersonalHabitsScreen> {

  final dataRepository = FirestoreBasicFieldRepository('users');
  final personalHabits = {
    for (var history in [
      'painkillerAbuse',
      'antibioticsAbuse',
      'smoking',
      'drinking'
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
              title: 'Painkiller abuse',
              state: personalHabits,
              field: 'painkillerAbuse'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Antibiotics abuse',
              state: personalHabits,
              field: 'antibioticsAbuse'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Smoking',
              state: personalHabits,
              field: 'smoking'
          ),
          const SizedBox(height: 20),
          SharedStatefulWidget.addSizedCheckBox(
              title: 'Drinking',
              state: personalHabits,
              field: 'drinking'
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _submit, child: const Text('Next'))
        ],
      ),
    ),
  );

  void _submit() async {
    await dataRepository.update(
        dataType: DataType.healthData,
        json: personalHabits
    );
    context.router.replaceNamed('/');
  }
}