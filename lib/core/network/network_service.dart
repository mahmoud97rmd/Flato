import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

enum NetworkStatus { online, offline }

class NetworkService {
  final _controller = StreamController<NetworkStatus>.broadcast();

  NetworkService() {
    Connectivity().onConnectivityChanged.listen((status) {
      if (status == ConnectivityResult.none) {
        _controller.add(NetworkStatus.offline);
      } else {
        _controller.add(NetworkStatus.online);
      }
    });
  }

  Stream<NetworkStatus> get networkStatusStream => _controller.stream;
}
