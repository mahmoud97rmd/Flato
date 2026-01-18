import 'dart:io';
import 'package:http/io_client.dart';

class CertificatePinning {
  static HttpClient getPinnedHttpClient() {
    final client = HttpClient();
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) {
      // ضع الـ SHA256 Pins الخاصة بـ OANDA هنا
      return cert.sha256 == "SHA256_PIN_OF_OANDA";
    };
    return client;
  }

  static IOClient getIOClient() => IOClient(getPinnedHttpClient());
}
