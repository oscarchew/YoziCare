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

  final firestoreBasicFieldRepository = FirestoreBasicFieldRepository('users');
  final firestoreArrayFieldRepository = FirestoreArrayFieldRepository('users');

  final pageController = PageController(
      initialPage: 0,
      viewportFraction: 0.85
  );
  var pageIndex = 0;

  // basicInfoCard()
  final genderEditingController = TextEditingController();
  final birthdayEditingController = TextEditingController();
  final weightEditingController = TextEditingController();
  DateTime? _birthday;
  bool isMale = true;

  // familyHistoryCard()
  final familyHistory = {
    for (var history in [
      'polycystic',
      'igAN',
      'liddle',
      'others'
    ]) history: false
  };

  // personalHistoryCard()
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

  // personalHabits()
  final personalHabits = {
    for (var history in [
      'painkillerAbuse',
      'antibioticsAbuse',
      'smoking',
      'drinking'
    ]) history: false
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 400,
          height: 400,
          child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              onPageChanged: (index) => setState(() => pageIndex = index),
              children: [
                basicInfoCard(),
                familyHistoryCard(),
                personalHistoryCard(),
                personalHabitCard()
              ]
          ),
        ),
        ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightGreen
            ),
            onPressed: _submitAndGoNextPage,
            icon: const Icon(Icons.navigate_next),
            label: const Text('Next')
        )
      ],
    )));
  }

  Card defaultCard(String title, List<Widget> widgets) => Card(
    color: Colors.green.withOpacity(0.1),
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    clipBehavior: Clip.hardEdge,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          color: Colors.lightGreen,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Center(child: Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),
        ),
        const SizedBox(height: 20,),
        Expanded(child: SingleChildScrollView(
          child: Column(
              children: widgets
          ),
        )),
        const SizedBox(height: 20,)
      ],
    ),
  );

  Card basicInfoCard() => defaultCard('Basic Info', [
    SharedStatefulWidget.addSizedOutlinedTextField(
        readOnly: true,
        onTap: _pickGender,
        controller: genderEditingController,
        labelText: 'Gender',
        color: Colors.lightGreen
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedOutlinedTextField(
        readOnly: true,
        onTap: _pickDate,
        controller: birthdayEditingController,
        labelText: 'Birthday',
        color: Colors.lightGreen
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedOutlinedTextField(
        controller: weightEditingController,
        labelText: 'Weight',
        color: Colors.lightGreen
    )
  ]);

  Card familyHistoryCard() => defaultCard('Family Medical History', [
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
  ]);

  Card personalHistoryCard() => defaultCard('Personal Medical History', [
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
  ]);

  Card personalHabitCard() => defaultCard('Personal Habits', [
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
    )
  ]);

  void _pickDate() async {
    _birthday = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
        builder: (context, child) => Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightGreen,
              onPrimary: Colors.white, // header text color
              onSurface: Colors.lightGreen, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.lightGreen
              ),
            ),
          ),
          child: child!,
        )
    );
    final birthday = _birthday!;
    birthdayEditingController.text =
    '${birthday.year}-${birthday.month}-${birthday.day}';
  }

  void _pickGender() async => await _pickGenderDialog(context);

  Future<void> _pickGenderDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) => SizedBox(width: 70, child: AlertDialog(
          backgroundColor: Colors.lightGreen,
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    value: true,
                    groupValue: isMale,
                    title: const Text('Male'),
                    activeColor: Colors.white,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
                RadioListTile(
                    value: false,
                    groupValue: isMale,
                    title: const Text('Female'),
                    activeColor: Colors.white,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
              ]),
        )));
    genderEditingController.text = isMale ? 'Male' : 'Female';
  }

  Future<void> _submitAndGoNextPage() async {
    switch (pageIndex) {
      case 0:
        if (_birthday == null || weightEditingController.text.isEmpty) {
          context.showSnackbar('Please fill in all the values!');
          break;
        }
        await firestoreBasicFieldRepository.update(
            dataType: DataType.healthData,
            json: {
              'gender': (isMale ? 'Male' : 'Female'),
              'birthday': Timestamp.fromDate(_birthday!),
              'weight': double.parse(weightEditingController.text)
            });
        nextPage();
        break;
      case 1:
        await firestoreBasicFieldRepository.update(
            dataType: DataType.healthData,
            json: familyHistory
        );
        nextPage();
        break;
      case 2:
        await firestoreBasicFieldRepository.update(
            dataType: DataType.healthData,
            json: personalHistory
        );
        nextPage();
        break;
      default:
        await firestoreBasicFieldRepository.update(
            dataType: DataType.healthData,
            json: personalHistory
        );
        context.router.replaceNamed('/');
        break;
    }
  }

  void nextPage() => pageController.nextPage(
      duration: const Duration(seconds: 1),
      curve: Curves.easeIn
  );
}