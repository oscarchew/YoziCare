import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';
import '../../../infrastructure/firestore/basic_repo.dart';
import '../shared/chart/chart_painter.dart';
import '../shared/chart/data.dart';
import '../shared/shared.dart';

class EgfrScreen extends StatefulWidget {

  const EgfrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EgfrScreenState();
}

class _EgfrScreenState extends State<EgfrScreen> {

  final firestoreArrayFieldRepository = FirestoreArrayFieldRepository('users');
  final firestoreBasicFieldRepository = FirestoreBasicFieldRepository('users');

  final crEditingController = TextEditingController();
  List<LineData> recentHistory = [];
  num lastEgfrValue = 0;

  @override
  void initState() {
    // Foreground
    registerForegroundFCM();
    // Background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {});
    // Terminated
    FirebaseMessaging.instance.getInitialMessage();

    super.initState();
  }

  Future<void> registerForegroundFCM() async {
    final settings = await FirebaseMessaging.instance.requestPermission();
    if (settings.authorizationStatus != AuthorizationStatus.authorized) return;

    FirebaseMessaging.onMessage.listen((message) async => await createDialog(
        title: message.notification!.title!,
        content: message.notification!.body!,
        actions: [
          ElevatedButton(
              child: const Text('OK'),
              onPressed: () => Navigator.pop(context))
        ]
    ));
  }

  @override
  Widget build(BuildContext context) {

    // will be decoupled afterwards
    final state = lastEgfrValue >= 60
        ? 'Lower than G2'
        : lastEgfrValue >= 30
        ? 'G3'
        : lastEgfrValue >= 15
        ? 'G4'
        : 'G5';

    // will be decoupled afterwards
    final suggestions = lastEgfrValue >= 60
        ? """[Maintenance of kidney functionality]
        - Healthy diet, Regular routine
        - Blood sugar / blood pressure control
        - Regular testing for kidney disease'"""
        : lastEgfrValue >= 15
        ? """[Prevention from ESRD]
        - Be sure to cooperate with treatment
        - Healthy habits
        - Avoiding eating foods high in phosphorus and salt
        - Phosphate binders (e.g., Calcium Carbonate)
        - Low-protein diet"""
        : """[]
        - Medications for loss of appetite and nausea
        - Erythropoietin or Iron for anemia
        - Prevention of Hyperkalemia and Pulmonary edema
        - May need kidney transplantation""";

    getRecentHistory();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('$state $suggestions'),
          const SizedBox(height: 20),
          CustomPaint(
              size: const Size(300, 400),
              painter: ChartPainter(
                  allLineData: recentHistory,
                  maxValue: 70.0,
                  drawStages: true
              )
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SharedStatefulWidget.addSizedOutlinedTextField(
                  controller: crEditingController,
                  labelText: 'New Cr'
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                  onPressed: _updateHistory,
                  child: const Text('Submit')
              )
            ],
          )
        ],
      ),
    );
  }

  void getRecentHistory() async {
    final updatedHistory = await firestoreArrayFieldRepository.get(
        dataType: DataType.eGFR
    );
    if (updatedHistory.isEmpty) return;
    if (updatedHistory.length == 1) updatedHistory.add(updatedHistory[0]);

    final startingIndexOfSampling = updatedHistory.length < 11
        ? 0
        : updatedHistory.length - 11;
    final updatedDataPoints = updatedHistory
        .getRange(startingIndexOfSampling, updatedHistory.length)
        .cast<num>()
        .toList()
        .toDataPoints();
    setState(() {
      lastEgfrValue = updatedHistory.last;
      recentHistory = [
        LineData(
            Colors.white,
            'Recent Cr History',
            updatedDataPoints
        )
      ];
    });
  }

  void _updateHistory() async {
    final healthData = await firestoreBasicFieldRepository.get(
        dataType: DataType.healthData
    );
    await firestoreArrayFieldRepository.update(
        dataType: DataType.eGFR,
        json: {
          'eGFR': eGFR(
              gender: healthData['gender'],
              age: (healthData['birthday'] as Timestamp)
                  .toDate()
                  .difference(DateTime.now())
                  .inDays ~/ 365,
              weight: healthData['weight'] / 1,
              cr: double.parse(crEditingController.text))
        });
    getRecentHistory();
  }

  Future<void> createDialog({
    required String title,
    required String content,
    required List<Widget> actions
  }) async => showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: actions
      )
  );

  double eGFR({
    required String gender,
    required int age,
    required double weight,
    required double cr
  }) {
    double result = (age > 60 || weight > 85)
        ? mdrd(gender == 'Male', age, cr)
        : cockcroftGault(gender == 'Male', age, weight, cr);
    return result > 60.0
        ? 60.0
        : result;
  }

  double mdrd(bool isMale, int age, double cr) {
    final c = isMale ? 1 : 0.742;
    return 186.0 * pow(cr, -1.154) * pow(age, -0.203) * c;
  }

  double cockcroftGault(bool isMale, int age, double weight, double cr) {
    final c = isMale ? 1 : 0.85;
    return (140.0 - age) * weight * c / (72.0 * cr);
  }
}