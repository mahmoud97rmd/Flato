import '../../../core/models/candle_entity.dart';

abstract class ExprNode {
  /// تقييم العقدة عند شمعة معينة
  bool evaluate(CandleEntity candle, int index);
}
