import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetState { online, offline }

class NetworkObserver {
  final _controller = StreamController<NetState>.broadcast();

  NetworkObserver() {
    Connectivity().onConnectivityChanged.listen((status) {
      _controller.add(status == ConnectivityResult.none
        ? NetState.offline : NetState.online);
    });
  }

  Stream<NetState> get stream => _controller.stream;
}
