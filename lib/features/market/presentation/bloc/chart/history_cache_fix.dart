import '../../../../core/models/candle_entity.dart';

class HistoryCacheFix {
  List<CandleEntity>? _lastCache;

  List<CandleEntity>? get cached => _lastCache;

  void save(List<CandleEntity> data) {
    _lastCache = data;
  }

  void clear() {
    _lastCache = null;
  }
}
