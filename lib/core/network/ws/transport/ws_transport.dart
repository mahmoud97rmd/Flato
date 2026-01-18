import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../pinning/ws_pinned_io.dart';
import '../../../core/settings/server_mode.dart';
import '../../../core/settings/mode_storage.dart';
import '../../../logging/audit_logger.dart';

typedef WsOnMsg = void Function(dynamic);

class WsTransport {
  WebSocketChannel? _channel;
  StreamSubscription? _sub;
  bool _manuallyClosed = false;

  Future<String> _baseUrl() async {
    final mode = await ModeStorage.load();
    return mode == ServerMode.live
        ? "wss://stream-fxtrade.oanda.com/v3"
        : "wss://stream-fxpractice.oanda.com/v3";
  }

  Future<void> connect({
    required String accountId,
    required String instruments,
    required Map<String, String> headers,
    required WsOnMsg onData,
  }) async {
    final base = await _baseUrl();
    final url =
        "\$base/accounts/\$accountId/pricing/stream?instruments=\$instruments";

    AuditLogger.log("WS CONNECT", {"url": url});

    _channel = await WsPinnedFactory.connectWithPinning(
      Uri.parse(url),
      headers,
    );

    _sub = _channel!.stream.listen((msg) {
      onData(msg);
    }, onError: (e) {
      AuditLogger.log("WS ERROR", {"error": e.toString()});
    });
  }

  void disconnect() {
    _sub?.cancel();
    _channel?.sink.close();
  }
}
