import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';
import '../shared/shared.dart';
import '../../../infrastructure/firestore/basic_repo.dart';

class BasicInfoScreen extends StatefulWidget {

  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {

  final firestoreBasicRepository = FirestoreBasicFieldRepository('users');
  final firestoreArrayRepository = FirestoreArrayFieldRepository('users');

  final genderEditingController = TextEditingController();
  final birthdayEditingController = TextEditingController();
  final weightEditingController = TextEditingController();

  DateTime? _birthday;
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SharedStatefulWidget.addSizedOutlinedTextField(
                    readOnly: true,
                    onTap: _pickGender,
                    controller: genderEditingController,
                    labelText: 'Gender'),
                const SizedBox(height: 20),
                SharedStatefulWidget.addSizedOutlinedTextField(
                    readOnly: true,
                    onTap: _pickDate,
                    controller: birthdayEditingController,
                    labelText: 'Birthday'),
                const SizedBox(height: 20),
                SharedStatefulWidget.addSizedOutlinedTextField(
                    controller: weightEditingController,
                    labelText: 'Weight'),
                const SizedBox(height: 20),
                ElevatedButton(onPressed: _submit, child: const Text('Next'))
              ],
            )));
  }

  void _pickDate() async {
    _birthday = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    final birthday = _birthday!;
    birthdayEditingController.text =
    '${birthday.year}-${birthday.month}-${birthday.day}';
  }

  void _pickGender() async => await _pickGenderDialog(context);

  Future<void> _pickGenderDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Select your gender'),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    value: true,
                    groupValue: isMale,
                    title: const Text('Male'),
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
                RadioListTile(
                    value: false,
                    groupValue: isMale,
                    title: const Text('Female'),
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
              ]),
        ));
    genderEditingController.text = isMale ? 'Male' : 'Female';
  }

  Future _submit() async {
    if (_birthday == null || weightEditingController.text.isEmpty) {
      context.showSnackbar('Please fill in all the values!');
    }
    await firestoreBasicRepository.update(
        dataType: DataType.healthData,
        json: {
          'gender': (isMale ? 'Male' : 'Female'),
          'birthday': Timestamp.fromDate(_birthday!),
          'weight': double.parse(weightEditingController.text)
        });
    context.router.replaceNamed('/family-history');
  }
}

