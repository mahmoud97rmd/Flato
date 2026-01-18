import 'package:flutter_bloc/flutter_bloc.dart';
import 'drawing_event.dart';
import 'drawing_state.dart';

class DrawingBloc extends Bloc<DrawingEvent, DrawingState> {
  List<List<Offset>> _trendlines = [];
  List<double> _horizontalLines = [];

  List<Offset> _currentPoints = [];

  DrawingBloc() : super(NoDrawing()) {
    on<StartTrendline>((event, emit) {
      _currentPoints = [];
      emit(DrawingTrendline(points: _currentPoints));
    });

    on<AddPointToTrendline>((event, emit) {
      _currentPoints.add(Offset(event.x, event.y));
      emit(DrawingTrendline(points: _currentPoints));
    });

    on<CompleteTrendline>((event, emit) {
      if (_currentPoints.length >= 2) {
        _trendlines.add(List<Offset>.from(_currentPoints));
      }
      _currentPoints = [];
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });

    on<AddHorizontalLine>((event, emit) {
      _horizontalLines.add(event.priceY);
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });

    on<ClearAllDrawings>((event, emit) {
      _trendlines.clear();
      _horizontalLines.clear();
      emit(DrawingComplete(
        trendlines: _trendlines,
        horizontalLines: _horizontalLines,
      ));
    });
  }
}
