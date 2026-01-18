import '../../core/models/candle_entity.dart';

class RangeFilterFix {
  List<CandleEntity> filterRange(
      List<CandleEntity> data, DateTime from, DateTime to) {
    return data.where((c) =>
        !c.timeUtc.isBefore(from) &&
        !c.timeUtc.isAfter(to)).toList();
  }
}
