import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BasicInfoScreen extends StatefulWidget {

  const BasicInfoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final genderEditingController = TextEditingController();
  final birthdayEditingController = TextEditingController();
  final weightEditingController = TextEditingController();

  DateTime? _birthday;
  bool isMale = true;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              addSizedOutlinedTextField(
                  readOnly: true,
                  onTap: _pickGender,
                  controller: genderEditingController,
                  labelText: 'Gender'),
              const SizedBox(height: 20),
              addSizedOutlinedTextField(
                  readOnly: true,
                  onTap: _pickDate,
                  controller: birthdayEditingController,
                  labelText: 'Birthday'),
              const SizedBox(height: 20),
              addSizedOutlinedTextField(
                  controller: weightEditingController,
                  labelText: 'Weight'),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text('Next'))
            ],
          )));

  SizedBox addSizedOutlinedTextField({
    required TextEditingController controller,
    required String labelText,
    bool readOnly = false,
    void Function()? onTap
  }) => SizedBox(
    width: 200,
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: labelText
      ),
    ),
  );

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

  void _submit() async {
    // Add data to Firestore
    if (_birthday == null || weightEditingController.text == '') {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
          content: Text('Please fill in all the values!')));
    }
    final docUser = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    final json = {
      'gender': (isMale ? 'Male' : 'Female'),
      'birthday': Timestamp.fromDate(_birthday!),
      'weight': weightEditingController.text
    };
    await docUser.set(json);

    // Jump to the next screen
    context.router.replaceNamed('/family-history');
  }
}
