import 'package:flutter/widgets.dart';
import '../persistence/persistent_state_manager.dart';

class AppLifecycleManager extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // مثال: استعادة حال Chart
      PersistentStateManager.load("chart_state")?.then((data) {
        // dispatch to ChartBloc
      });
    }
  }
}
