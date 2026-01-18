import 'package:flutter_test/flutter_test.dart';
import 'package:your_app/core/sync/sync_manager.dart';
import 'package:your_app/core/network/ws_manager.dart';
import 'package:your_app/core/network/rest_client.dart';
import 'package:your_app/features/market/data/streaming/tick_aggregator.dart';

void main() {
  test('SyncManager processes ticks and builds candles', () async {
    final ws = WSManager('wss://echo.websocket.events');
    final rest = RestClient('','');
    final agg = TickAggregator("SYM", Duration(seconds: 60));
    bool called = false;

    final manager = SyncManager(
      ws: ws,
      rest: rest,
      aggregator: agg,
      onCandle: (c) => called = true,
    );

    manager.start();
    await Future.delayed(Duration(seconds: 1));
    await manager.stop();

    expect(called, true);
  });
}
