import 'dart:io';
import 'package:http/io_client.dart';
import '../../core/settings/server_mode.dart';
import '../../core/settings/mode_storage.dart';
import 'pin_store.dart';

class HttpPinningClient {
  static Future<IOClient> create() async {
    final mode = await ModeStorage.load();

    final httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        final pins = mode == ServerMode.live
            ? PinStore.liveRestPins
            : PinStore.sandboxRestPins;
        return pins.contains(cert.sha256);
      };
    return IOClient(httpClient);
  }
}
