abstract class PositionsState {}

class PositionsIdle extends PositionsState {}

class PositionsLoading extends PositionsState {}

class PositionsLoaded extends PositionsState {
  final List positionList;
  PositionsLoaded(this.positionList);
}

class PositionsError extends PositionsState {
  final String message;
  PositionsError(this.message);
}
