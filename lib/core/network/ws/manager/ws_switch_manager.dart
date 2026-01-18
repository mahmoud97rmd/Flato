import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';

class WsSwitchManager {
  WebSocketChannel? _currentChannel;
  StreamSubscription? _currentSub;

  void switchTo(String url, void Function(dynamic) onData) {
    // الغاء القديم
    _currentSub?.cancel();
    _currentChannel?.sink.close();

    // فتح جديد
    _currentChannel = WebSocketChannel.connect(Uri.parse(url));
    _currentSub = _currentChannel!.stream.listen(onData);
  }

  Future<void> dispose() async {
    await _currentSub?.cancel();
    _currentChannel?.sink.close();
    _currentChannel = null;
    _currentSub = null;
  }
}
