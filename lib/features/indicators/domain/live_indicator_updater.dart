import '../../../core/models/tick_entity.dart';
import '../../../core/models/candle_entity.dart';

class LiveIndicatorUpdater {
  CandleEntity _current = CandleEntity(...); // يبدأ من آخر شمعة

  void onTick(TickEntity tick) {
    // تحديث High/Low/Close لحظيًا
    final mid = (tick.price.ask + tick.price.bid) / 2;
    _current = CandleEntity(
      instrument: _current.instrument,
      timeUtc: _current.timeUtc,
      open: _current.open,
      high: mid > _current.high ? mid : _current.high,
      low: mid < _current.low ? mid : _current.low,
      close: mid,
      volume: _current.volume + 1,
    );

    // إرسال المؤشرات للمراقبين
  }
}
