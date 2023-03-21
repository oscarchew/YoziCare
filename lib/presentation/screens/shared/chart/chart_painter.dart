import 'package:flutter/material.dart';
import '../../../../domain/database/firestore.dart';
import './data.dart';
import './chart_utils.dart';

class ChartPainter extends CustomPainter {

  final xLabelHeight = 40;
  final double maxValue;
  final List<LineData> allLineData;
  final bool drawStages;

  ChartPainter({
    required this.allLineData,
    required this.maxValue,
    this.drawStages = false
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawStages) canvas.drawStages(size);
    if (allLineData.isNotEmpty) {
      final xInterval = size.width / (allLineData[0].points.length - 1);
      canvas.drawLineData(
          allLineData: allLineData,
          xInterval: xInterval,
          chartHeight: size.height,
          maxValue: maxValue
      );
    }
    // canvas.drawAxis(size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}