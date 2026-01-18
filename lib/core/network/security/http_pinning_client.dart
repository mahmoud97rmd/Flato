import 'dart:io';
import 'package:http/io_client.dart';
import '../pinning/pin_store.dart';
import '../../settings/mode_storage.dart';
import '../../settings/server_mode.dart';

class HttpPinningClient {
  static Future<IOClient> create() async {
    final mode = await ModeStorage.load();
    final pins = mode == ServerMode.live
        ? [...PinStore.liveRestPins, ...PinStore.liveStreamPins]
        : [...PinStore.sandboxRestPins, ...PinStore.sandboxStreamPins];

    final httpClient = HttpClient()
      ..badCertificateCallback = (cert, host, port) {
        final sha256 = cert.sha256;
        return pins.contains(sha256);
      };

    return IOClient(httpClient);
  }
}
