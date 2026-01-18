abstract class ComparisonState {}

class ComparisonIdle extends ComparisonState {}

class ComparisonRunning extends ComparisonState {}

class ComparisonSuccess extends ComparisonState {
  final Map<String, dynamic> results;
  ComparisonSuccess(this.results);
}

class ComparisonError extends ComparisonState {
  final String message;
  ComparisonError(this.message);
}
