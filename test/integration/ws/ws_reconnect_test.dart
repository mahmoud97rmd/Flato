import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/network/ws_manager.dart';

void main() {
  test('WSManager reconnect logic', () async {
    final ws = WSManager('wss://echo.websocket.events');
    ws.connect();
    await Future.delayed(Duration(seconds: 2));
    ws.send('test');

    final data = await ws.stream.first;
    expect(data, isNotNull);

    ws.dispose();
  });
}
