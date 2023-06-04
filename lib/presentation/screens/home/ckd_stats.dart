import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../domain/database/firestore.dart';
import '../../../infrastructure/firestore/array_repo.dart';
import '../../../infrastructure/firestore/basic_repo.dart';
import '../../../infrastructure/google_auth/google_auth_repo.dart';
import '../shared/chart/chart_painter.dart';
import '../shared/chart/data.dart';
import '../shared/shared.dart';

@RoutePage()
class EgfrScreen extends StatefulWidget {

  const EgfrScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EgfrScreenState();
}

class _EgfrScreenState extends State<EgfrScreen> {

  final firestoreArrayFieldRepository = FirestoreArrayFieldRepository('users');
  final firestoreBasicFieldRepository = FirestoreBasicFieldRepository('users');

  // eGFR Card
  final crEditingController = TextEditingController();
  num lastEgfr = 0;
  List<LineData> recentEgfrHistory = [];

  // Hydration Card
  final hydrationEditingController = TextEditingController();
  final urinationEditingController = TextEditingController();
  num lastUrination = 1500;
  List<LineData> recentHydrationHistory = [];

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

    FirebaseMessaging.onMessage.listen((message) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
            backgroundColor: Colors.lightGreen,
            title: Text(message.notification!.title!),
            content: Text(message.notification!.body!),
            actions: [ElevatedButton(
                child: Text('ok'.i18n()),
                onPressed: () => Navigator.pop(context)
            )]
        ))
    );
  }

  @override
  Widget build(BuildContext context) {
    getRecentEgfrHistory();
    getRecentHydrationHistory();
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 400,
          height: 550,
          child: PageView(
            controller: PageController(viewportFraction: 0.85),
            children: [
              Stack(
                fit: StackFit.expand,
                children: [
                  egfrCard(),
                  Positioned(
                      bottom: 20,
                      right: 20,
                      child: egfrFAB()
                  )
                ],
              ),
              Stack(
                fit: StackFit.expand,
                children: [
                  hydrationCard(),
                  Positioned(
                      bottom: 20,
                      right: 20,
                      child: hydrationFAB()
                  )
                ],
              ),
            ],
          ),
        )],
    ));
  }

  Card egfrCard () => Card(
      color: Colors.green.withOpacity(0.1),
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomPaint(
                size: const Size(350, 270),
                painter: ChartPainter(
                    allLineData: recentEgfrHistory,
                    maxValue: 70.0,
                    drawStages: true
                )
            ),
            Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    Text(
                      'current-egfr'.i18n(),
                      style: const TextStyle(
                          fontSize: 20,
                          color: Colors.lightGreen
                      ),
                    ),
                    Text(
                      currentState(lastEgfr),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.green
                      ),
                    )
                  ],
                )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  currentSuggestions(lastEgfr),
                  style: const TextStyle(fontSize: 15),
                )
            )
          ]
      )
  );

  Card hydrationCard () => Card(
      color: Colors.green.withOpacity(0.1),
      shadowColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)
      ),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.lightGreen[200],
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'water-intake-title'.i18n(),
                      style: const TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'and'.i18n(),
                      style: const TextStyle(color: Colors.lightGreen, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'urination-title'.i18n(),
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
            CustomPaint(
                size: const Size(350, 300),
                painter: ChartPainter(
                    allLineData: recentHydrationHistory,
                    maxValue: 2500,
                    drawStages: false
                )
            ),
            Padding(
                padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    top: 15
                ),
                child: Text(
                  'recommended-hydration'.i18n(),
                  style: const TextStyle(
                      fontSize: 20,
                      color: Colors.lightGreen
                  ),
                )
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  '${lastUrination + 500} ~ ${lastUrination + 700} mL',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green
                  ),
                )
            )
          ]
      )
  );

  FloatingActionButton egfrFAB() => FloatingActionButton(
      foregroundColor: Colors.white,
      backgroundColor: Colors.lightGreen,
      elevation: 0,
      child: const Icon(Icons.add),
      onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: Colors.lightGreen[200],
              content: SizedBox(
                  width: 200,
                  height: 90,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SharedStatefulWidget.addSizedOutlinedTextField(
                          controller: crEditingController,
                          labelText: 'new-cr'.i18n()
                      ),
                    ],
                  )
              ),
              actions: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightGreen
                    ),
                    onPressed: () {
                      _updateEgfrHistory();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.send),
                    label: Text('submit'.i18n())
                )
              ]
          ))
  );

  FloatingActionButton hydrationFAB() => FloatingActionButton(
      foregroundColor: Colors.white,
      backgroundColor: Colors.lightGreen,
      elevation: 0,
      child: const Icon(Icons.add),
      onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
              backgroundColor: Colors.lightGreen[200],
              content: SizedBox(
                  width: 200,
                  height: 180,
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SharedStatefulWidget.addSizedOutlinedTextField(
                          controller: hydrationEditingController,
                          labelText: 'hydration-today'.i18n()
                      ),
                      const SizedBox(height: 20),
                      SharedStatefulWidget.addSizedOutlinedTextField(
                          controller: urinationEditingController,
                          labelText: 'urination-today'.i18n()
                      )
                    ],
                  )
              ),
              actions: [
                ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightGreen
                    ),
                    onPressed: () {
                      _updateHydrationHistory();
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.send),
                    label: Text('submit'.i18n())
                )
              ]
          )
      )
  );

  void getRecentEgfrHistory() async {
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
      lastEgfr = updatedHistory.last;
      recentEgfrHistory = [
        LineData(
            Colors.white,
            'Recent Cr History',
            updatedDataPoints
        )
      ];
    });
  }

  void _updateEgfrHistory() async {
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
    getRecentEgfrHistory();
  }

  void _updateHydrationHistory() async {
    await firestoreArrayFieldRepository.update(
        dataType: DataType.hydration,
        json: {'hydration': int.parse(hydrationEditingController.text)}
    );
    await firestoreArrayFieldRepository.update(
        dataType: DataType.urination,
        json: {'urination': int.parse(urinationEditingController.text)}
    );
    getRecentHydrationHistory();
  }

  void getRecentHydrationHistory() async {
    final updatedHydrationHistory = await firestoreArrayFieldRepository.get(
        dataType: DataType.hydration
    );
    final updatedUrinationHistory = await firestoreArrayFieldRepository.get(
        dataType: DataType.urination
    );
    if (updatedHydrationHistory.isEmpty) return;

    var dataLength = updatedHydrationHistory.length;
    if (dataLength == 1) {
      updatedHydrationHistory.add(updatedHydrationHistory[0]);
      updatedUrinationHistory.add(updatedUrinationHistory[0]);
      ++dataLength;
    }
    final startingIndexOfSampling = dataLength < 11
        ? 0
        : dataLength - 11;
    final updatedHydrationDataPoints = updatedHydrationHistory
        .getRange(startingIndexOfSampling, dataLength)
        .cast<num>()
        .toList()
        .toDataPoints();
    final updatedUrinationDataPoints = updatedUrinationHistory
        .getRange(startingIndexOfSampling, dataLength)
        .cast<num>()
        .toList()
        .toDataPoints();
    setState(() {
      lastUrination = updatedUrinationHistory.last;
      recentHydrationHistory = [
        LineData(
            Colors.green,
            'recent-hydration'.i18n(),
            updatedHydrationDataPoints
        ),
        LineData(
            Colors.white,
            'recent-urination'.i18n(),
            updatedUrinationDataPoints
        )
      ];
    });
  }

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

  String currentState(num egfr) => egfr >= 60 ? 'G1 ~ G2'
      : egfr >= 30 ? 'G3'
      : egfr >= 15 ? 'G4'
      : egfr != 0  ? 'G5'
      : 'no-cr-yet'.i18n();

  String currentSuggestions(num egfr) => egfr >= 60 ? 'suggestion-1'.i18n()
      : egfr >= 15 ? 'suggestion-2'.i18n()
      : egfr != 0  ? 'suggestion-3'.i18n()
      : 'please-enter-one-cr'.i18n();
}