import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class PingManager {
  final WebSocketChannel channel;
  late Timer _timer;

  PingManager(this.channel);

  void start() {
    _timer = Timer.periodic(Duration(seconds: 20), (_) {
      channel.sink.add('ping');
    });
  }

  void stop() {
    _timer.cancel();
  }
}
