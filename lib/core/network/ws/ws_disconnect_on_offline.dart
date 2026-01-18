import 'ws_channel_manager.dart';
import '../network_observer.dart';

class WsDisconnectOnOffline {
  final WSChannelManager manager;
  final NetworkObserver observer;

  WsDisconnectOnOffline(this.manager, this.observer) {
    observer.stream.listen((state) {
      if (state == NetState.offline) {
        manager.dispose();
      }
    });
  }
}
