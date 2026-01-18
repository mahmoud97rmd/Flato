import '../../../core/models/candle_entity.dart';

class VisibleSynchronizerFix {
  List<CandleEntity> sync(
      List<CandleEntity> all, DateTime from, DateTime to) {
    return all.where((c) =>
        !c.timeUtc.isBefore(from) && !c.timeUtc.isAfter(to)).toList();
  }
}
