import 'package:flutter/material.dart';
import 'package:gdsc/domain/database/firestore.dart';

import '../../../infrastructure/firestore/array_repo.dart';
import '../shared/chart/chart_painter.dart';
import '../shared/chart/data.dart';
import '../shared/shared.dart';

class HydrationAnalysisScreen extends StatefulWidget {

  const HydrationAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HydrationAnalysisScreenState();
}

class _HydrationAnalysisScreenState extends State<HydrationAnalysisScreen> {

  final firestoreRepository = FirestoreArrayFieldRepository('users');

  final hydrationEditingController = TextEditingController();
  final urinationEditingController = TextEditingController();
  List<LineData> recentHistory = [];
  num lastUrinationValue = 0;

  @override
  Widget build(BuildContext context) {
    getRecentHistory();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomPaint(
              size: const Size(300, 400),
              painter: ChartPainter(
                  allLineData: recentHistory,
                  maxValue: 3000
              )
          ),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SharedStatefulWidget.addSizedOutlinedTextField(
                    controller: hydrationEditingController,
                    labelText: 'Today\'s hydration'
                ),
                SharedStatefulWidget.addSizedOutlinedTextField(
                    controller: urinationEditingController,
                    labelText: 'Today\'s urination'
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                    onPressed: _updateHistory,
                    child: const Text('Submit')
                ),
              ]
          ),
          const SizedBox(height: 20),
          Text('Recommended water intake: ${lastUrinationValue + 500} - ${lastUrinationValue + 700}')
        ],
      ),
    );
  }

  void _updateHistory() async {
    await firestoreRepository.update(
        dataType: DataType.hydration,
        json: {'hydration': int.parse(hydrationEditingController.text)}
    );
    await firestoreRepository.update(
        dataType: DataType.urination,
        json: {'urination': int.parse(urinationEditingController.text)}
    );
    getRecentHistory();
  }

  void getRecentHistory() async {
    final updatedHydrationHistory = await firestoreRepository.get(
        dataType: DataType.hydration
    );
    final updatedUrinationHistory = await firestoreRepository.get(
        dataType: DataType.urination
    );
    if (updatedHydrationHistory.isEmpty) return;

    final dataLength = updatedHydrationHistory.length;
    if (dataLength == 1) {
      updatedHydrationHistory.add(updatedHydrationHistory[0]);
      updatedUrinationHistory.add(updatedUrinationHistory[0]);
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
      lastUrinationValue = updatedUrinationHistory.last;
      recentHistory = [
        LineData(
            Colors.blue,
            'Recent Hydration History',
            updatedHydrationDataPoints
        ),
        LineData(
            Colors.yellow,
            'Recent Urination History',
            updatedUrinationDataPoints
        )
      ];
    }
    );
  }
}