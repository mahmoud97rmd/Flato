import '../../../core/models/candle_entity.dart';

class ReplayVolumeFix {
  double lastVolume = 0;

  void track(CandleEntity candle) {
    lastVolume = candle.volume;
  }
}
