import 'dart:async';

class NetworkBounceHandlerFix {
  Timer? _bounceTimer;

  void onNetworkChange(bool isOnline, void Function() onReconnect) {
    _bounceTimer?.cancel();
    if (isOnline) {
      _bounceTimer = Timer(Duration(seconds: 1), onReconnect);
    }
  }
}
