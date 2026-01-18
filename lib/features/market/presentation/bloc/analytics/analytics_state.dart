abstract class AnalyticsState {}

class AnalyticsIdle extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final dynamic result;
  AnalyticsLoaded(this.result);
}

class AnalyticsError extends AnalyticsState {
  final String message;
  AnalyticsError(this.message);
}
