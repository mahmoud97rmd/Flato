import 'package:flutter/widgets.dart';
import '../ws_channel_manager.dart';

class WsLifecycleHandler extends WidgetsBindingObserver {
  final WSChannelManager manager;

  WsLifecycleHandler(this.manager);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      manager.dispose();
    }
  }
}
