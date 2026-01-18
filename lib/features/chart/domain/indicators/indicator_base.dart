import 'package:flutter/material.dart';

abstract class Indicator {
  final String name;
  Indicator(this.name);

  /// Accept candles and return list of values for drawing
  List<double> compute(List<double> prices);
  Color get color;
}
