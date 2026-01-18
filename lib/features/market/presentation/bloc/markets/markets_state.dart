abstract class MarketsState {}

class MarketsIdle extends MarketsState {}

class MarketsLoading extends MarketsState {}

class MarketsLoaded extends MarketsState {
  final List<String> instruments;
  MarketsLoaded(this.instruments);
}

class MarketsEmpty extends MarketsState {}

class MarketsError extends MarketsState {
  final String message;
  MarketsError(this.message);
}
