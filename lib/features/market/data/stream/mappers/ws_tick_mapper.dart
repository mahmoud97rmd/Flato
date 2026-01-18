import '../../domain/entities/candle.dart';
import '../dtos/ws_tick_dto.dart';

class WsTickMapper {
  /// تحويل Tick إلى Candle لحظي
  static Candle toCandle(WsTickDTO dto) {
    final bidPrice = dto.bids?.first["price"] ?? 0;
    final askPrice = dto.asks?.first["price"] ?? 0;

    final mid = ((double.parse(bidPrice.toString()) +
                double.parse(askPrice.toString())) /
            2);

    final date = DateTime.parse(dto.time);

    return Candle(
      time: date,
      open: mid,
      high: mid,
      low: mid,
      close: mid,
      volume: null,
    );
  }
}
