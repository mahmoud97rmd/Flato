import 'alert_condition.dart';

class AlertEngine {
  final List<AlertCondition> conditions;
  final Map<String, DateTime> _startMap = {};

  AlertEngine(this.conditions);

  List<String> evaluate(Map<String, double> indicatorValues) {
    final now = DateTime.now();
    final triggered = <String>[];

    for (final cond in conditions) {
      final value = indicatorValues[cond.indicator] ?? 0;
      final satisfied = _compare(value, cond.operator, cond.threshold);

      final key = cond.indicator + cond.operator + cond.threshold.toString();
      if (satisfied) {
        _startMap.putIfAbsent(key, () => now);
        if (now.difference(_startMap[key]!) >= cond.duration) {
          triggered.add('${cond.indicator} ${cond.operator} ${cond.threshold}');
        }
      } else {
        _startMap.remove(key);
      }
    }

    return triggered;
  }

  bool _compare(double v, String op, double t) {
    switch (op) {
      case '>': return v > t;
      case '<': return v < t;
      case '>=': return v >= t;
      case '<=': return v <= t;
      case '==': return v == t;
      default: return false;
    }
  }
}
