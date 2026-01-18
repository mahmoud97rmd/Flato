abstract class RootEvent {}

class InitApp extends RootEvent {}

class TerminateApp extends RootEvent {}

class ConnectionStatusChanged extends RootEvent {
  final bool connected;
  ConnectionStatusChanged(this.connected);
}

class GlobalErrorOccurred extends RootEvent {
  final String message;
  GlobalErrorOccurred(this.message);
}
