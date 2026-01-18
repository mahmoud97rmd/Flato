import 'package:flutter/material.dart';
import 'network_observer.dart';

class NetworkStateListener extends StatefulWidget {
  final Widget child;
  NetworkStateListener(this.child);

  @override
  _NetworkStateListenerState createState() => _NetworkStateListenerState();
}

class _NetworkStateListenerState extends State<NetworkStateListener> {
  @override
  void initState() {
    super.initState();
    NetworkObserver().stream.listen((state) {
      setState(() {}); // triggers rebuild to show Online/Offline
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
