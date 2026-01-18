import 'package:web_socket_channel/web_socket_channel.dart';

class WsErrorHandler {
  void bind(WebSocketChannel channel, void Function(dynamic) onData) {
    channel.stream.listen(
      (msg) => onData(msg),
      onError: (_) => channel.sink.close(),
      onDone: () => channel.sink.close(),
    );
  }
}
