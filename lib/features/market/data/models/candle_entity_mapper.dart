import '../../domain/entities/candle.dart';
import 'candle_model.dart';

extension ToEntity on CandleModel {
  CandleEntity toEntity() {
    return CandleEntity(
      time: time,
      open: open,
      high: high,
      low: low,
      close: close,
      volume: volume,
    );
  }
}
