abstract class DrawingEvent {}

class StartTrendline extends DrawingEvent {}

class AddPointToTrendline extends DrawingEvent {
  final double x;
  final double y;
  AddPointToTrendline({required this.x, required this.y});
}

class CompleteTrendline extends DrawingEvent {}

class ClearAllDrawings extends DrawingEvent {}

class AddHorizontalLine extends DrawingEvent {
  final double priceY;
  AddHorizontalLine({required this.priceY});
}
