
bool _disposed = false;
void startStreaming() {
  _connect();
}

void _connect() async {
  final channel = IOWebSocketChannel.connect(_url);

  channel.stream.listen((msg) {
    _lastReceivedTime = DateTime.now();
    _onMessage(msg);
  }, onError: (e) {
    if (!_disposed) Future.delayed(Duration(seconds: 2), () => _connect());
  }, onDone: () {
    if (!_disposed) Future.delayed(Duration(seconds: 2), () => _connect());
  });

  _startHeartbeatMonitor();
}

void _startHeartbeatMonitor() {
  Timer.periodic(Duration(seconds: 10), (t) {
    if (DateTime.now().difference(_lastReceivedTime).inSeconds > 30) {
      // reconnect
      _connect();
    }
  });
}

void dispose() {
  _disposed = true;
}
