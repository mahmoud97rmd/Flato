import 'dart:io';
import 'package:web_socket_channel/io.dart';

class WsCertPinning {
  static IOWebSocketChannel connectPinned(
      String url, SecurityContext context) {
    return IOWebSocketChannel.connect(
      url,
      customClient: HttpClient(context: context),
    );
  }
}
