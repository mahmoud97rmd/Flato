import 'indicator_type.dart';

class IndicatorSeries {
  final List<double> values;
  final String label;
  final IndicatorDisplayMode displayMode;

  IndicatorSeries({
    required this.values,
    required this.label,
    required this.displayMode,
  });
}
