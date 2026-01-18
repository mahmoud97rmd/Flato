abstract class RootState {}

class AppUninitialized extends RootState {}

class AppReady extends RootState {}

class AppTerminated extends RootState {}

class AppErrorState extends RootState {
  final String message;
  AppErrorState(this.message);
}

class ConnectivityState extends RootState {
  final bool online;
  ConnectivityState(this.online);
}
