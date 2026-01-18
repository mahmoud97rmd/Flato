import 'dart:io';
import 'package:web_socket_channel/io.dart';
import '../../core/settings/server_mode.dart';
import '../../core/settings/mode_storage.dart';
import 'pin_store.dart';

class WsPinnedFactory {
  static Future<IOWebSocketChannel> connectWithPinning(
      Uri uri, Map<String, dynamic> headers) async {
    final mode = await ModeStorage.load();
    final pins = mode == ServerMode.live
        ? PinStore.liveStreamPins
        : PinStore.sandboxStreamPins;

    final client = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        return pins.contains(cert.sha256);
      };

    return IOWebSocketChannel.connect(
      uri,
      customClient: client,
      headers: headers,
    );
  }
}
