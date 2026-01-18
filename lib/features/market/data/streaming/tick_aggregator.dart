import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';
import '../../../core/time/time_canon.dart';

class TickAggregator {
  final String instrument;
  final Duration timeframe;
  CandleEntity? _current;
  final List<CandleEntity> archive = [];

  TickAggregator(this.instrument, this.timeframe);

  void addTick(TickEntity tick) {
    final tickTime = tick.timeUtc;

    if (_current == null) {
      _current = _newCandleFromTick(tick);
      return;
    }

    // إذا قفز الزمن أكثر من timeframe → فجوة
    if (tickTime.difference(_current!.timeUtc) >= timeframe) {
      archive.add(_current!);
      _current = _newCandleFromTick(tick);
      return;
    }

    // تحديث High/Low/Close
    _current = CandleEntity(
      instrument: instrument,
      timeUtc: _current!.timeUtc,
      open: _current!.open,
      high: tick.price.of(PriceType.mid) > _current!.high
          ? tick.price.of(PriceType.mid)
          : _current!.high,
      low: tick.price.of(PriceType.mid) < _current!.low
          ? tick.price.of(PriceType.mid)
          : _current!.low,
      close: tick.price.of(PriceType.mid),
      volume: _current!.volume + 1,
    );
  }

  CandleEntity _newCandleFromTick(TickEntity t) {
    final p = t.price.of(PriceType.mid);
    return CandleEntity(
      instrument: instrument,
      timeUtc: t.timeUtc,
      open: p,
      high: p,
      low: p,
      close: p,
      volume: 1,
    );
  }

  List<CandleEntity> buildCandles() {
    return List.unmodifiable(archive);
  }
}
