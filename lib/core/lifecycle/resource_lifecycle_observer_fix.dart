import 'package:flutter/widgets.dart';

class ResourceLifecycleObserverFix extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      // إغلاق الموارد هنا
    }
  }
}
