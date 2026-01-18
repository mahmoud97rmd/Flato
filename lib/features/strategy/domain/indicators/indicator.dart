import '../../../core/models/candle_entity.dart';

abstract class Indicator<T> {
  void addCandle(CandleEntity candle); // تحديث بالقيمة الجديدة
  T get current;                        // آخر قيمة
  List<T> get series;                  // السلسلة التاريخية (اختياري)
}
