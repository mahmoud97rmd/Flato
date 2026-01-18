import 'package:web_socket_channel/web_socket_channel.dart';

class WSChannelManager {
  WebSocketChannel? _channel;
  String? _currentSymbol;

  WebSocketChannel? get channel => _channel;

  void connectForSymbol(String symbol, String url) {
    if (_currentSymbol == symbol) {
      return; // Already connected for same
    }
    _disconnect();
    _currentSymbol = symbol;
    _channel = WebSocketChannel.connect(Uri.parse("$url?symbol=$symbol"));
  }

  void _disconnect() {
    _channel?.sink.close();
    _channel = null;
    _currentSymbol = null;
  }

  void dispose() => _disconnect();
}
