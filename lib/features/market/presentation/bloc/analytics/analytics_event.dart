abstract class AnalyticsEvent {}

class ComputeAnalytics extends AnalyticsEvent {
  final List<double> profits;
  ComputeAnalytics(this.profits);
}
