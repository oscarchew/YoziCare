import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';
import '../shared/shared.dart';
import '../../../infrastructure/firestore/basic_repo.dart';

@RoutePage()
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
      crossAxisAlignment: CrossAxisAlignment.center,
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
            label: Text('next'.i18n())
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
        Expanded(child: Center(child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widgets
          ),
        ))),
        const SizedBox(height: 20,)
      ],
    ),
  );

  Card basicInfoCard() => defaultCard('basic-info-title'.i18n(), [
    SharedStatefulWidget.addSizedOutlinedTextField(
        readOnly: true,
        onTap: _pickGender,
        controller: genderEditingController,
        labelText: 'gender'.i18n(),
        borderColor: Colors.lightGreen
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedOutlinedTextField(
        readOnly: true,
        onTap: _pickDate,
        controller: birthdayEditingController,
        labelText: 'birthday'.i18n(),
        borderColor: Colors.lightGreen
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedOutlinedTextField(
        controller: weightEditingController,
        labelText: 'weight'.i18n(),
        borderColor: Colors.lightGreen
    )
  ]);

  Card familyHistoryCard() => defaultCard('family-history-title'.i18n(), [
    SharedStatefulWidget.addSizedCheckBox(
        title: 'polycystic'.i18n(),
        state: familyHistory,
        field: 'polycystic'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'igan'.i18n(),
        state: familyHistory,
        field: 'igAN'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'liddle'.i18n(),
        state: familyHistory,
        field: 'liddle'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'others'.i18n(),
        state: familyHistory,
        field: 'others'
    ),
  ]);

  Card personalHistoryCard() => defaultCard('personal-history-title'.i18n(), [
    SharedStatefulWidget.addSizedCheckBox(
        title: 'diabetes'.i18n(),
        state: personalHistory,
        field: 'diabetes'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'hypertension'.i18n(),
        state: personalHistory,
        field: 'hypertension'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'hyperuricemia'.i18n(),
        state: personalHistory,
        field: 'hyperuricemia'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'gout'.i18n(),
        state: personalHistory,
        field: 'gout'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'hematuria'.i18n(),
        state: personalHistory,
        field: 'hematuria'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'proteinuria'.i18n(),
        state: personalHistory,
        field: 'proteinuria'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'renal-colic'.i18n(),
        state: personalHistory,
        field: 'renalColic'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'frequent-urination'.i18n(),
        state: personalHistory,
        field: 'frequentUrination'
    ),
  ]);

  Card personalHabitCard() => defaultCard('personal-habits-title'.i18n(), [
    SharedStatefulWidget.addSizedCheckBox(
        title: 'painkiller-abuse'.i18n(),
        state: personalHabits,
        field: 'painkillerAbuse'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'antibiotics-abuse'.i18n(),
        state: personalHabits,
        field: 'antibioticsAbuse'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'smoking'.i18n(),
        state: personalHabits,
        field: 'smoking'
    ),
    const SizedBox(height: 20),
    SharedStatefulWidget.addSizedCheckBox(
        title: 'drinking'.i18n(),
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
          backgroundColor: Colors.lightGreen[200],
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                RadioListTile(
                    value: true,
                    groupValue: isMale,
                    title: Text('male'.i18n()),
                    activeColor: Colors.lightGreen,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
                RadioListTile(
                    value: false,
                    groupValue: isMale,
                    title: Text('female'.i18n()),
                    activeColor: Colors.lightGreen,
                    onChanged: (val) {
                      setState(() => isMale = val!);
                      Navigator.pop(context);
                    }
                ),
              ]),
        )));
    genderEditingController.text = isMale ? 'male'.i18n() : 'female'.i18n();
  }

  Future<void> _submitAndGoNextPage() async {
    switch (pageIndex) {
      case 0:
        if (_birthday == null || weightEditingController.text.isEmpty) {
          context.showSnackbar('enter-all-values'.i18n());
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
            json: personalHabits
        );
        context.router.replaceNamed('/');
        break;
    }
  }

  void nextPage() => pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn
  );
}