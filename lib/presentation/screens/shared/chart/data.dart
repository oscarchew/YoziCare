import 'dart:ui';

import 'package:collection/collection.dart';

class DataPoint {

  final String xLabel;
  final num yLabel;

  DataPoint(this.xLabel, this.yLabel);
}

class LineData {

  final Color color;
  final String name;
  final List<DataPoint> points;

  LineData(this.color, this.name, this.points);
}

extension DoublesToDataPointsUtil on List<num> {

  List<DataPoint> toDataPoints() =>
    mapIndexed((index, element) =>
      DataPoint(index.toString(), element)).toList();
}

extension DataPointsToOffsetsUtil on List<DataPoint> {

  List<Offset> toOffsets({
    required double xInterval,
    required double chartHeight,
    double maxValue = 70.0
  }) =>
    mapIndexed((index, dataPoint) => Offset(
        index * xInterval,
        chartHeight - (chartHeight / maxValue * dataPoint.yLabel)
    )).toList();
}