import 'package:flutter/widgets.dart';

class RouterObserverFix extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    // إيقاف Replay / Streams
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    // مماثل
  }
}
