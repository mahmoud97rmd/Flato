import 'package:flutter/foundation.dart';
import '../ws_transport.dart';
import '../../retry/retry_policy.dart';

class WsTransportRetry {
  final RetryPolicy _retry = RetryPolicy(maxAttempts: 4);

  Future<void> connectWithRetry({
    required String accountId,
    required String instrument,
    required Function(dynamic) onData,
    required WsTransport transport,
  }) async {
    await _retry.execute(() {
      return transport.connect(
        accountId: accountId,
        instrument: instrument,
        onData: onData,
      );
    }, onRetry: (attempt, delay, type) {
      debugPrint("WS RETRY \$attempt delay=\$delay type=\$type");
    });
  }
}
