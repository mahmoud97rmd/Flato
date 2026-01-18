import '../../../core/models/candle_entity.dart';

class BacktestPreflightCheck {
  bool validate(List<CandleEntity> history, int minCandles) {
    if (history.length < minCandles) return false;
    // أي شروط إضافية حسب الاستراتيجية
    return true;
  }
}
