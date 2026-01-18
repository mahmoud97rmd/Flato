import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaStreamClient {
  WebSocketChannel? _channel;

  void connect(String symbol, Function(dynamic

// ========================================

// ==== Code Block 1706 ====
cat > lib/core/network/oanda/stream/oanda_ws_client.dart << 'EOF'
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaWSClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subs;

  void connect(String symbol, void Function(dynamic) onData,
      {void Function()? onDone, void Function(dynamic)? onError}) async {
    final token = await SecureStorageManager.readOandaToken();
    final url =
        "\${OandaConfig.streamBaseUrl}/accounts/\${await SecureStorageManager.readOandaAccount()}/pricing/stream?instruments=\$symbol";
    _channel = WebSocketChannel.connect(
      Uri.parse(url),
      headers: {"Authorization": "Bearer \$token"},
    );

    _subs = _channel!.stream.listen(
      onData,
      onError: onError,
      onDone: onDone,
    );
  }

  void disconnect() {
    _subs?.cancel();
    _channel?.sink.close();
  }
}
