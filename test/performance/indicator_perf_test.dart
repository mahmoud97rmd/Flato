import 'package:test/test.dart';
import '../../../lib/features/indicators/engine/indicator_engine.dart';
import '../../../lib/features/indicators/plugins/ema_plugin.dart';

void main() {
  test('EMA performance on 50k candles', () {
    final candles = List.generate(
      50000,
      (i) => CandleEntity(...), // mock data
    );

    final engine = IndicatorEngine([EMAPlugin(50)]);

    final sw = Stopwatch()..start();
    final result = engine.calculate(candles);
    sw.stop();

    print("Execution time: ${sw.elapsedMilliseconds} ms");

    expect(sw.elapsedMilliseconds < 300, true); // أقل من 300ms
  });
}
