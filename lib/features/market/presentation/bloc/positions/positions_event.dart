abstract class PositionsEvent {}

class LoadPositions extends PositionsEvent {}

class ClosePositionEvent extends PositionsEvent {
  final String instrument;
  ClosePositionEvent(this.instrument);
}

class ModifyPositionEvent extends PositionsEvent {
  final String instrument;
  final double stopLoss;
  final double takeProfit;
  ModifyPositionEvent({
    required this.instrument,
    required this.stopLoss,
    required this.takeProfit,
  });
}
