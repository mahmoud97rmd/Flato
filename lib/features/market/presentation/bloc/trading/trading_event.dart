abstract class TradingEvent {}

class PlaceOrder extends TradingEvent {
  final String instrument;
  final OrderSide side;
  final double price;
  final double size;

  PlaceOrder({
    required this.instrument,
    required this.side,
    required this.price,
    required this.size,
  });
}

class ClosePosition extends TradingEvent {
  final String positionId;

  ClosePosition({required this.positionId});
}

class RefreshPositions extends TradingEvent {}
