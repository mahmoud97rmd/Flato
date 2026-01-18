abstract class EmptyState {}

class LoadingState {}

class HasDataState<T> {
  final T data;
  HasDataState(this.data);
}

class NoDataState extends EmptyState {}
