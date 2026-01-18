import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/features/market/data/candle_normalizer.dart';
import 'package:your_app/market/domain/entities/candle.dart';

void main() {
  test('fillGaps should produce continuous candles', () {
    final input = [
      CandleEntity(time: DateTime(2025,1,1,10,0), open:1,high:1,low:1,close:1,volume:1),
      CandleEntity(time: DateTime(2025,1,1,10,2), open:2,high:2,low:2,close:2,volume:1),
    ];
    final output = CandleNormalizer.fillGaps(input, Duration(minutes:1));
    expect(output.length, 3);
    expect(output[1].volume, 0);
  });
}
