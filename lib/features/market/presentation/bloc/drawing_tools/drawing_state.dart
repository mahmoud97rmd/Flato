import 'package:flutter/material.dart';

abstract class DrawingState {}

class NoDrawing extends DrawingState {}

class DrawingTrendline extends DrawingState {
  final List<Offset> points;
  DrawingTrendline({required this.points});
}

class DrawingComplete extends DrawingState {
  final List<List<Offset>> trendlines;
  final List<double> horizontalLines;
  DrawingComplete({
    required this.trendlines,
    required this.horizontalLines,
  });
}
