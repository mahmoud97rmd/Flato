import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/strategy/domain/evaluator/example_strategy.dart';
import 'package:your_app/core/models/candle_entity.dart';

void main() {
  test('SequentialEvaluator produces signals', () {
    final history = List.generate(30, (i) => CandleEntity(
      instrument: "EUR_USD",
      timeUtc: DateTime.utc(2025,1,1,0,i),
      open: i.toDouble(),
      high: i.toDouble() + 1,
      low: i.toDouble() - 1,
      close: i.toDouble(),
      volume: 1,
    ));

    final evaluator = buildExampleStrategy();
    final signals = evaluator.evaluateSeries(history);

    expect(signals.length, history.length);
  });
}
