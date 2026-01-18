import 'package:flutter/widgets.dart';

class RouterBlocCleanup extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPop(Route route, Route? previousRoute) {
    if (route is PageRoute) {
      // dispatch cleanup event to relevant Blocs
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute) {
      // dispatch cleanup event
    }
  }
}
