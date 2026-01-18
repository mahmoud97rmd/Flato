import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../oanda_config.dart';
import '../../../core/security/secure_storage_manager.dart';

class OandaWSClient {
  WebSocketChannel? _channel;
  StreamSubscription? _subs;
  bool _manuallyClosed = false;

  Future<void> connect(
    String symbol,
    void Function(dynamic) onData, {
    void Function()? onDone,
    void Function(dynamic)? onError,
  }) async {
    _manuallyClosed = false;
    final token = await SecureStorageManager.readOandaToken();
    final account =
        await SecureStorageManager.readOandaAccount();

    final url =
        "\${OandaConfig.streamBaseUrl}/accounts/\$account/pricing/stream?instruments=\$symbol";

    _channel = WebSocketChannel.connect(
      Uri.parse(url),
      headers: {"Authorization": "Bearer \$token"},
    );

    _subs = _channel!.stream.listen(
      onData,
      onError: (e) {
        onError?.call(e);
        if (!_manuallyClosed) {
          // إعادة الاتصال بعد 2 ثانية
          Future.delayed(Duration(seconds: 2), () {
            connect(symbol, onData,
                onDone: onDone, onError: onError);
          });
        }
      },
      onDone: () {
        onDone?.call();
        if (!_manuallyClosed) {
          Future.delayed(Duration(seconds: 2), () {
            connect(symbol, onData,
                onDone: onDone, onError: onError);
          });
        }
      },
    );
  }

  void disconnect() {
    _manuallyClosed = true;
    _subs?.cancel();
    _channel?.sink.close();
  }
}
