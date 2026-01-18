import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WSSmartReconnectFix {
  WebSocketChannel? _chan;
  final String url;
  Timer? _retry;
  int _fails = 0;

  WSSmartReconnectFix(this.url);

  void connect(void Function(dynamic) onData) {
    _chan?.sink.close();
    _chan = WebSocketChannel.connect(Uri.parse(url));
    _chan!.stream.listen(onData, onError: (_) => scheduleReconnect(onData),
        onDone: () => scheduleReconnect(onData));
    _fails = 0;
  }

  void scheduleReconnect(void Function(dynamic) onData) {
    _retry?.cancel();
    _fails++;
    final delay = Duration(seconds: 2 * _fails);
    _retry = Timer(delay, () => connect(onData));
  }

  void dispose() {
    _retry?.cancel();
    _chan?.sink.close();
  }
}
