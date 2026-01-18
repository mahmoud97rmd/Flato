import '../../domain/trading/trade_position.dart';
import '../../domain/entities/candle.dart';
import '../../domain/trading/trade_result.dart';

class VirtualExchange {
  final List<TradePosition> openPositions = [];
  final List<TradeResult> tradeHistory = [];

  void openPosition(TradePosition position) {
    openPositions.add(position);
  }

  void updateWithNewCandle(CandleEntity candle) {
    for (var position in List.of(openPositions)) {
      final currentPrice = candle.close;

      if (position.type == TradeType.BUY) {
        if (currentPrice >= position.takeProfit ||
            currentPrice <= position.stopLoss) {
          _closePosition(position, currentPrice, candle.time);
        }
      }
      if (position.type == TradeType.SELL) {
        if (currentPrice <= position.takeProfit ||
            currentPrice >= position.stopLoss) {
          _closePosition(position, currentPrice, candle.time);
        }
      }
    }
  }

  void _closePosition(
    TradePosition position,
    double exitPrice,
    DateTime exitTime,
  ) {
    double profit = (position.type == TradeType.BUY)
        ? exitPrice - position.entryPrice
        : position.entryPrice - exitPrice;

    final result = TradeResult(
      profit: profit,
      entryPrice: position.entryPrice,
      exitPrice: exitPrice,
      entryTime: position.entryTime,
      exitTime: exitTime,
    );

    openPositions.remove(position);
    tradeHistory.add(result);
  }
}
