import 'dart:io';
import 'package:web_socket_channel/io.dart';
import '../pinning/pin_store.dart';
import '../../settings/mode_storage.dart';
import '../../settings/server_mode.dart';

class WsPinningFactory {
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
      headers: headers.cast<String, dynamic>(),
    );
  }
}
