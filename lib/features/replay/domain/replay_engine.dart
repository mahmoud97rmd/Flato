import '../../../core/models/candle_entity.dart';

typedef ReplayTickCallback = void Function(CandleEntity);

class ReplayEngine {
  final List<CandleEntity> history;
  int _index = 0;
  bool _isPlaying = false;
  Duration _speedFactor = Duration(milliseconds: 500); // 2x real

  ReplayEngine(this.history);

  void play(ReplayTickCallback onTick) async {
    _isPlaying = true;
    while (_isPlaying && _index < history.length) {
      onTick(history[_index]);
      await Future.delayed(_speedFactor);
      _index++;
    }
  }

  void pause() => _isPlaying = false;

  void resume(ReplayTickCallback onTick) => play(onTick);

  void stop() {
    _isPlaying = false;
    _index = 0;
  }

  void setSpeed(double factor) {
    _speedFactor = Duration(milliseconds: (1000 / factor).round());
  }
}
