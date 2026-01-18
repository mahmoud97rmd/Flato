import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/ws/smart/ws_smart_manager.dart';
import '../../../../core/network/network_observer.dart';

class WSBloc extends Cubit<void> {
  final WSSmartManager manager;

  WSBloc(this.manager) : super(null);

  void start(String symbol) {
    manager.connect((data) {
      // dispatch into ChartBloc/OrderBookBloc
    });
  }

  @override
  Future<void> close() async {
    manager.dispose(); // clean
    return super.close();
  }
}
