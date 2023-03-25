import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import './data.dart';

enum Direction {
  vertical,
  horizontal
}

extension PathUtils on Path {

  void bezierPointsTo(List<Offset> points, Direction direction) {
    if (points.length < 2) return;

    if (direction == Direction.vertical) {
      for (int i = 1; i < points.length; ++i) {
        final currentPoint = points[i];
        final nextPoint = points[i - 1];
        cubicTo(
            nextPoint.dx,
            (currentPoint.dy + nextPoint.dy) / 2,
            currentPoint.dx,
            (currentPoint.dy + nextPoint.dy) / 2,
            currentPoint.dx,
            currentPoint.dy
        );
      }
    } else {
      for (int i = 1; i < points.length; ++i) {
        final currentPoint = points[i];
        final nextPoint = points[i - 1];
        cubicTo(
            (currentPoint.dx + nextPoint.dx) / 2,
            nextPoint.dy,
            (currentPoint.dx + nextPoint.dx) / 2,
            currentPoint.dy,
            currentPoint.dx,
            currentPoint.dy
        );
      }
    }
  }
}

extension CanvasUtils on Canvas {

  void drawAxis(Size size) {
    final axisPoints = [
      Offset.zero,
      Offset(0, size.height),
      Offset(size.width, size.height)
    ];
    final axisPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    drawPoints(
        PointMode.polygon,
        axisPoints,
        axisPaint
    );
  }

  void drawStages(Size size) {
    final line0 = [
      DataPoint('', 0), DataPoint('', 0)
    ].toOffsets(xInterval: size.width, chartHeight: size.height);
    final line15 = [
      DataPoint('', 15), DataPoint('', 15)
    ].toOffsets(xInterval: size.width, chartHeight: size.height);
    final line30 = [
      DataPoint('', 30), DataPoint('', 30)
    ].toOffsets(xInterval: size.width, chartHeight: size.height);
    final line60 = [
      DataPoint('', 60), DataPoint('', 60)
    ].toOffsets(xInterval: size.width, chartHeight: size.height);
    final line70 = [
      DataPoint('', 70), DataPoint('', 70)
    ].toOffsets(xInterval: size.width, chartHeight: size.height);

    var opacity = 0.8;

    for (var g in [
      [...line60, ...line70.reversed],
      [...line30, ...line60.reversed],
      [...line15, ...line30.reversed],
      [...line0 , ...line15.reversed]
    ]) {
      drawPath(
          Path()
            ..moveTo(g[0].dx, g[0].dy)
            ..lineTo(g[1].dx, g[1].dy)
            ..lineTo(g[2].dx, g[2].dy)
            ..lineTo(g[3].dx, g[3].dy),
          Paint()
            ..color = Colors.green.withOpacity(opacity)
      );
      opacity -= 0.2;
    }
  }

  void drawLineData({
    required List<LineData> allLineData,
    required double xInterval,
    required double chartHeight,
    double maxValue = 70.0
  }) {
    for (var data in allLineData) {

      final points = data.points
          .toOffsets(xInterval: xInterval, chartHeight: chartHeight, maxValue: maxValue);

      drawPath(
          Path()
            ..moveTo(0, chartHeight)
            ..lineTo(0, points[0].dy)
            ..bezierPointsTo(points, Direction.horizontal)
            ..lineTo(xInterval * (points.length - 1), chartHeight),
          Paint()
            ..color = data.color.withOpacity(0.5)
      );

      for (var point in points) {
        drawCircle(point, 2.5, Paint()..color = data.color);
      }
      drawCircle(points.last, 3.5, Paint()..color = Colors.red);
    }
  }
}